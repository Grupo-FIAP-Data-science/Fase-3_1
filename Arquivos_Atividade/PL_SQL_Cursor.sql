SET SERVEROUTPUT ON;
DECLARE
    -- Item a) Criação do cursor
    CURSOR sac_cursor IS
        SELECT
            s.nr_sac AS numero_ocorrencia_sac,
            s.dt_abertura_sac AS data_abertura_sac,
            s.hr_abertura_sac AS hora_abertura_sac,
            s.tp_sac AS tipo_sac,
            s.nr_indice_satisfacao as indice_satisfacao,
            p.cd_produto AS codigo_prod,
            p.ds_produto AS nome_prod,
            p.vl_unitario AS vl_unitario_prod,
            p.vl_perc_lucro AS percentual_lucro_prod,
            c.nr_cliente AS numero_cliente,
            c.nm_cliente AS nome_cliente
        FROM
            mc_sgv_sac s
            JOIN mc_produto p ON s.cd_produto = p.cd_produto
            JOIN mc_cliente c ON s.nr_cliente = c.nr_cliente;
        
    v_tipo_sac VARCHAR(25);
    v_unitario_lucro_prod mc_produto.vl_unitario%TYPE;
    v_sg_estado mc_estado.sg_estado%TYPE;
    v_nm_estado mc_estado.nm_estado%TYPE;
    v_aliquota_icms mc_aliquota_media_icms_estado.vl_perc_aliquota_media%TYPE;
    v_icms_produto mc_sgv_ocorrencia_sac.vl_icms_produto%TYPE;
    v_cursor sac_cursor%rowtype;
    v_numero_sac mc_sgv_ocorrencia_sac.nr_ocorrencia_sac%TYPE;
    
BEGIN
    IF NOT sac_cursor%ISOPEN THEN
        OPEN sac_cursor;
    END IF;
    
    LOOP
        FETCH sac_cursor INTO v_cursor;
        EXIT WHEN sac_cursor%NOTFOUND;
        
        -- Item b.1) Classificação dos Tipos de SAC
        CASE
            WHEN v_cursor.tipo_sac = 'S' THEN v_tipo_sac := 'SUGESTÃO';
            WHEN v_cursor.tipo_sac = 'D' THEN v_tipo_sac := 'DÚVIDA';
            WHEN v_cursor.tipo_sac = 'E' THEN v_tipo_sac := 'ELOGIO';
            ELSE v_tipo_sac := 'CLASSIFICAÇÃO INVÁLIDA';
        END CASE;
        
        -- Item b.2) Calculando o valor do lucro unitário do produto
        v_unitario_lucro_prod := (v_cursor.percentual_lucro_prod/100)*v_cursor.vl_unitario_prod;                
        
        BEGIN
            -- Item b.3) Recuperando as informações SG_ESTADO e NM_ESTADO
            SELECT
                est.sg_estado,
                est.nm_estado
            INTO
                v_sg_estado,
                v_nm_estado
            FROM
                mc_end_cli e
            JOIN mc_logradouro l ON e.cd_logradouro_cli = l.cd_logradouro
            JOIN mc_bairro b ON l.cd_bairro = b.cd_bairro
            JOIN mc_cidade cid ON b.cd_cidade = cid.cd_cidade
            JOIN mc_estado est ON cid.sg_estado = est.sg_estado
            WHERE
                e.nr_cliente = v_cursor.numero_cliente;
            
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Não foi possível encontrar informações de estado para o cliente ' || v_cursor.numero_cliente);
                CONTINUE; -- Continua para a próxima iteração do loop
        END;

        BEGIN
            -- Item b.4) Recuperando e calculando o valor médio do ICMS do produto
            SELECT 
               fun_mc_gera_aliquota_media_icms_estado(v_sg_estado)
            INTO
                v_aliquota_icms
            FROM
                dual;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Não foi possível encontrar informações de estado para o cliente ' || v_cursor.numero_cliente);
                CONTINUE; -- Continua para a próxima iteração do loop
        END;
            
        v_icms_produto := (v_aliquota_icms/100)*v_cursor.vl_unitario_prod;
        
        BEGIN
            SELECT 
                nr_ocorrencia_sac INTO v_numero_sac
            FROM 
                mc_sgv_ocorrencia_sac
            WHERE 
                nr_ocorrencia_sac = v_cursor.numero_ocorrencia_sac;
            
                -- O número de SAC já existe na tabela
            UPDATE mc_sgv_ocorrencia_sac
            SET dt_abertura_sac = v_cursor.data_abertura_sac,
            hr_abertura_sac = v_cursor.hora_abertura_sac,
            ds_tipo_classificacao_sac = v_tipo_sac,
            ds_indice_satisfacao_atd_sac = v_cursor.indice_satisfacao,
            cd_produto = v_cursor.codigo_prod,
            ds_produto = v_cursor.nome_prod,
            vl_unitario_produto = v_cursor.vl_unitario_prod,
            vl_perc_lucro = v_cursor.percentual_lucro_prod,
            vl_unitario_lucro_produto = v_unitario_lucro_prod,
            sg_estado = v_sg_estado,
            nm_estado = v_nm_estado,
            nr_cliente = v_cursor.numero_cliente,
            nm_cliente = v_cursor.nome_cliente,
            vl_icms_produto = v_icms_produto
            WHERE nr_ocorrencia_sac = v_cursor.numero_ocorrencia_sac;
                
            DBMS_OUTPUT.PUT_LINE('Os dados do SAC número ' || v_cursor.numero_ocorrencia_sac || ' foram atualizados!');            

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO mc_sgv_ocorrencia_sac (
                        nr_ocorrencia_sac,
                        dt_abertura_sac,
                        hr_abertura_sac,
                        ds_tipo_classificacao_sac,
                        ds_indice_satisfacao_atd_sac,
                        cd_produto,
                        ds_produto,
                        vl_unitario_produto,
                        vl_perc_lucro,
                        vl_unitario_lucro_produto,
                        sg_estado,
                        nm_estado,
                        nr_cliente,
                        nm_cliente,
                        vl_icms_produto)
                    VALUES (
                        v_cursor.numero_ocorrencia_sac,
                        v_cursor.data_abertura_sac,
                        v_cursor.hora_abertura_sac,
                        v_tipo_sac,
                        v_cursor.indice_satisfacao,
                        v_cursor.codigo_prod,
                        v_cursor.nome_prod,
                        v_cursor.vl_unitario_prod,
                        v_cursor.percentual_lucro_prod,
                        v_unitario_lucro_prod,
                        v_sg_estado,
                        v_nm_estado,
                        v_cursor.numero_cliente,
                        v_cursor.nome_cliente,
                        v_icms_produto
                    );
                    DBMS_OUTPUT.PUT_LINE('Dados inseridos na tabela MC_SGV_OCORRENCIA_SAC para o SAC número: ' || v_cursor.numero_ocorrencia_sac);
        END;
    END LOOP;   
    -- Encerrando o cursor
    CLOSE sac_cursor;
END;
/

SELECT * FROM MC_SGV_OCORRENCIA_SAC;