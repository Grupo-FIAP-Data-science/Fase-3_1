CREATE TABLE "MC_ALIQUOTA_MEDIA_ICMS_ESTADO" 
(	"SG_ESTADO" CHAR(2), 
"VL_PERC_ALIQUOTA_MEDIA" NUMBER(8,2)
) 

COMMENT ON COLUMN "MC_ALIQUOTA_MEDIA_ICMS_ESTADO"."SG_ESTADO" IS 'Essa  coluna  ir� receber a sigla do estado.';
COMMENT ON COLUMN "MC_ALIQUOTA_MEDIA_ICMS_ESTADO"."VL_PERC_ALIQUOTA_MEDIA" IS 'Essa  coluna  ir� receber a aliquota media do estado.';
REM INSERTING into MC_ALIQUOTA_MEDIA_ICMS_ESTADO
SET DEFINE OFF;
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('AC',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('AL',12);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('AM',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('AP',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('BA',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('CE',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('DF',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('ES',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('GO',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('MA',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('MT',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('MS',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('MG',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('PA',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('PB',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('PR',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('PE',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('PI',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('RN',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('RS',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('RJ',20);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('RO',17.5);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('RR',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('SC',17);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('SP',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('SE',18);
Insert into MC_ALIQUOTA_MEDIA_ICMS_ESTADO (SG_ESTADO,VL_PERC_ALIQUOTA_MEDIA) values ('TO',18);
--------------------------------------------------------
--  DDL for Index PK_MC_ALIQUOTA_MEDIA_ICMS_ESTADO
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MC_ALIQUOTA_MEDIA_ICMS_ESTADO" ON "MC_ALIQUOTA_MEDIA_ICMS_ESTADO" ("SG_ESTADO");
--------------------------------------------------------
--  Constraints for Table MC_ALIQUOTA_MEDIA_ICMS_ESTADO
--------------------------------------------------------

  ALTER TABLE "MC_ALIQUOTA_MEDIA_ICMS_ESTADO" ADD CONSTRAINT "PK_MC_ALIQUOTA_MEDIA_ICMS_ESTADO" PRIMARY KEY ("SG_ESTADO");
  ALTER TABLE "MC_ALIQUOTA_create or replace function fun_mc_gera_aliquota_media_icms_estado(p_sg_estado in varchar) return number is 
v_vl_perc_aliquota_media number;
begin
	begin
		select 	vl_perc_aliquota_media
		into	v_vl_perc_aliquota_media
		from	mc_aliquota_media_icms_estado
        where   sg_estado = p_sg_estado;
	exception
		when others then
				v_vl_perc_aliquota_media := 00;
	end;
    return v_vl_perc_aliquota_media;
end;MEDIA_ICMS_ESTADO" MODIFY ("VL_PERC_ALIQUOTA_MEDIA" NOT NULL ENABLE);



