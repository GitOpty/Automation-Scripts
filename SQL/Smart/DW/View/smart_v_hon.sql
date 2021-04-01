CREATE VIEW
    [dbo].[v_bi_hon]
AS
select 
    hon_seq
    ,hon_med
    ,hon_ctf
    ,hon_cnv_cod
    ,hon_dthr_ini
    ,HON_DTHR_ALT as hon_DT_ATUALIZACAO
    ,hon_psv_solic
    ,hon_pc1
    ,hon_pc2
    ,hon_pc3
    ,hon_pc4
    ,hon_pc5
from hon