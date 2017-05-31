create or replace view VW_IDEA_STATUS
as
select  e.valor status , count(1) quantity
from    tb_idea i
        ,tb_listavalordetalle e
where   i.id_t_lv_estadoidea = e.id
group   by e.valor
/
