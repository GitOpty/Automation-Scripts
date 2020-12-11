begin TRAN
declare @rls INT
declare @rls_novo INT
set @rls = 1250
set @rls_novo = 1393 
update rls
    set rls_estrutura = (select rls_estrutura from rls where rls_cod = @rls_novo)
where 
    rls_cod = @rls
delete from ars where ars_rls_cod = @rls_novo
delete from rls_alter where rls_a_rls_cod = @rls_novo
delete from rls where rls_cod = @rls_novo
--commit
--rollback