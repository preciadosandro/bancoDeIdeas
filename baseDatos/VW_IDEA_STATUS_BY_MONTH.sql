create or replace view VW_IDEA_STATUS_BY_MONTH
as
select  to_char(i.creadoen, 'yyyy-mm') month,  e.valor status, count(1) quantity
from    tb_idea i
        ,tb_listavalordetalle e
where   i.id_t_lv_estadoidea = e.id
group   by to_char(i.creadoen, 'yyyy-mm'), e.valor
order   by 2 desc, 1
/
