#!/bin/bash

export ORACLE_HOME=/Library/Oracle/instantclient_11_2
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${ORACLE_HOME}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ORACLE_HOME}

ora_sysuser=user1
ora_syspw=user1
ora_conn=//crdRepo/slob

ora_user=tpcc
ora_pw=tpcc

TEST_DIR=`dirname $0`

sqlcmd_out=sqlcmd.out
sqlcmd_in=sqlcmd.in

echo "Executing from Diretory $TEST_DIR
sqlcmd input:$sqlcmd_in
sqlcmd output:$sqlcmd_out
"

echo "Test db connections..."


conn=$ora_sysuser/$ora_syspw@$ora_conn
echo "
set termout OFF;
select count(*) from dual;
set termout ON;
"|tee -a $sqlcmd_in| sqlplus -S $conn >$sqlcmd_out

cmd_ret="$?"
if [ "$cmd_ret" -ne 0 ]; then
    echo "failed making connection to:$conn"
    exit 1
fi


echo "drop user $ora_user"
echo "
drop user $ora_user cascade;
"|tee -a $sqlcmd_in| sqlplus -S $conn >>$sqlcmd_out

cmd_ret="$?"
if [ "$cmd_ret" -ne 0 ]; then
    echo "Failed to drop user $ora_user"
    exit 1
fi


echo "create user $ora_user"
echo "
create user $ora_user identified by $ora_pw;
grant connect,resource to $ora_user;
"|tee -a $sqlcmd_in| sqlplus -S $conn >>$sqlcmd_out

cmd_ret="$?"
if [ "$cmd_ret" -ne 0 ]; then
    echo "Failed to create user $ora_user"
    exit 1
fi

conn=$ora_user/$ora_pw@$ora_conn

echo "Test user $ora_user"
echo "
drop table tmp_1;
create table tmp_1(first_name varchar2(200));
drop table tmp_1;
"|tee -a $sqlcmd_in| sqlplus -S $conn >>$sqlcmd_out

cmd_ret="$?"
if [ "$cmd_ret" -ne 0 ]; then
    echo "Test new user $ora_user failed."
    exit 1
fi


# echo "create schema for TPC-C"
# cat  $TEST_DIR/src/com/oltpbenchmark/benchmarks/tpcc/ddls/tpcc-oracle-ddl.sql |tee -a $sqlcmd_in| sqlplus -S $conn >>$sqlcmd_out



# cmd_ret="$?"
# if [ "$cmd_ret" -ne 0 ]; then
#     echo "create TPC-C schema objects failed."
#     exit 1
# fi

# echo "Tables created successfully!"

echo "Before data loading ..."
echo "
set echo on;
select 'WAREHOUSE' table_name,count(*) cnt from WAREHOUSE
union all
select 'district' ,count(*) cnt from district
union all
select 'CUSTOMER',count(*) from CUSTOMER
union all
select 'stock',count(*) from stock
union all
select 'HISTORY',count(*) from HISTORY
union all
select 'item',count(*) from item
union all
select 'OORDER',count(*) from OORDER
union all
select 'new_ORDER',count(*) from new_ORDER
;
"|tee -a $sqlcmd_in| sqlplus -S $conn |tee -a $sqlcmd_out


echo "Loading tpcc data..."
./oltpbenchmark -b tpcc -c $TEST_DIR/config/tpcc_oracle_config.xml --create=true --load=true 

cmd_ret="$?"

echo "
set echo on;
select 'WAREHOUSE' table_name,count(*) cnt from WAREHOUSE
union all
select 'district' ,count(*) cnt from district
union all
select 'CUSTOMER',count(*) from CUSTOMER
union all
select 'stock',count(*) from stock
union all
select 'HISTORY',count(*) from HISTORY
union all
select 'item',count(*) from item
union all
select 'OORDER',count(*) from OORDER
union all
select 'new_ORDER',count(*) from new_ORDER
;
"|tee -a $sqlcmd_in| sqlplus -S $conn |tee -a $sqlcmd_out

if [ "$cmd_ret" -ne 0 ]; then
    echo "Loading tpcc data failed."
    exit 1
fi
echo "Load exit code => $?"

