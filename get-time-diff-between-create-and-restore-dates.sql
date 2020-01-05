with last_restored as
(
select
databasename = sd.[name]
,   sd.[create_date]
,   sd.[compatibility_level]
,   sd.[collation_name]
,   rh.*
,   rownum = row_number() over (partition by sd.name order by rh.[restore_date] desc) from
master.sys.databases sd left outer join msdb.dbo.[restorehistory] rh on rh.[destination_database_name] = sd.name join master.sys.database_mirroring sdm on sd.database_id = sdm.database_id --where
--sd.database_id > 4
--and   sd.state_desc = 'online'
--and   sdm.mirroring_role_desc is null
--or    sdm.mirroring_role_desc != 'mirror'
)
select
'database' = upper(databasename)
,   'created_on' = replace(replace(left(create_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date)
--, 'restored_on' = replace(replace(left(restore_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date) ,    'restored_on' =
case
when restore_date is not null then replace(replace(left(restore_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date) else ''
end
,   'time_between' =
case
when restore_date is null then ''
else
cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 / 30 / 12 as nvarchar(50)) + ' years, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 / 30 % 12 as nvarchar(50)) + ' months, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 % 30 as nvarchar(50)) + ' days, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 % 24 as nvarchar(50)) + ' hours, '
+ cast(datediff(second, create_date, restore_date) / 60 % 60 as nvarchar(50)) + ' minutes '
+ cast(datediff(second, create_date, restore_date) % 60 as nvarchar(50)) + ' seconds ' end
 
from
[last_restored]
where
[rownum] = 1
and databasename not in ('master', 'model', 'msdb', 'tempdb')
