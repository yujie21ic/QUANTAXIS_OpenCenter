classdef DSMysql<handle & Message.QMMes
    properties
        MYSQL
        
    end
    events
        mysqlexec
    end
    methods
        function DM=DSMysql()
            DM.DSMysqlInit();
            addlistener(DM,'mysqlexec',@DSMYSQLEXEC);
        end
        function DM=DSMysqlInit(DM)
            DM.MYSQL.DatabaseName=[];
            DM.MYSQL.TableName=[];
            DM.MYSQL.Describe=[];
            DM.MYSQL.User=[];
            DM.MYSQL.Password=[];
            DM.MYSQL.Url=[];
            DM.MYSQL.Sqlquery=[];
            DM.MYSQL.Driver = 'com.mysql.jMCc.Driver';
            DM.MYSQL.ConfigID=[];
            DM.DSMysqlConfig();
        end
    end
    methods
        function DM=DSMysqlConnect(DM,varargin)
            if isempty(DM.MYSQL.DatabaseName)
                DM.MYSQL.DatabaseName=input('Database(example:quantaxis)\n DatabBase:  ','s');
            end
            if isempty(DM.MYSQL.User)
                DM.MYSQL.User=input('User(example:root) \nName:  ','s');
            end
            if isempty(DM.MYSQL.Password)
                DM.MYSQL.Password =input('Password:  ','s');
            end
            DM.MYSQL.Driver = 'com.mysql.jMCc.Driver';
            if isempty(DM.MYSQL.Url)
                DM.MYSQL.Url=input('Url(example:localhost)\nURL:  ','s');
            end
            DM.MYSQL.Databaseurl = ['jdbc:mysql://',DM.MYSQL.Url,':3306/',DM.MYSQL.DatabaseName];
            DM.MYSQL.Conn = database(DM.MYSQL.DatabaseName,DM.MYSQL.User,DM.MYSQL.Password,DM.MYSQL.Driver,DM.MYSQL.Databaseurl);
            DM.MYSQL.Status=isopen(DM.MYSQL.Conn);
            if DM.MYSQL.Status==1
                DM.MES.Str='[SQL]:Connection Successfully\n[SQL]:Using MYSQL\n';
                fprintf(DM.MES.Str);
                notify(DM,'QAMessage')
                
            end
        end
        function DM=DSMysqlConfig(DM,varargin)
            if isempty(DM.MYSQL.ConfigID)
                DM.MYSQL.ConfigID=input('ConfigID: (1 for default, 2 for self\n ID:');
            end
            switch DM.MYSQL.ConfigID
                case {1}
                    DM.MYSQL.DatabaseName='quantaxis';
                    DM.MYSQL.User='root';
                    DM.MYSQL.Password='940809';
                    DM.MYSQL.Url='localhost';
                    DM.DSMysqlConnect();
                case {2}
                    DM.DSMysqlConnect();
            end
            
            
        end
    end
    methods(Access = 'public')
        function DM=DSMysqlCreateTable(DM,varargin)
            if isempty(DM.MYSQL.DatabaseName)
                DM.MYSQL.DatabaseName=input('Database(example:quantaxis)\n DatabBase:  ','s');
            end
            if isempty(DM.MYSQL.TableName)
                DM.MYSQL.TableName=input('TableName(example:000001_ts) \nName:  ','s');
            end
            if isempty(DM.MYSQL.Describe)
                DM.MYSQL.Describe =input('Describe(example:(`DATE`DOUBLE NULL)) \nName','s');
            end
            DM.MYSQL.Sqlquery=['CREATE TABLE if not exists `',DM.MYSQL.DatabaseName,'`.`',DM.MYSQL.TableName,'` ', DM.MYSQL.Describe,';'];
            disp(DM.MYSQL.Sqlquery);
            DM.MES.Str=['your sql query is:',DM.MYSQL.Sqlquery];
            notify(DM,'QAMessage');
            exec(DM.MYSQL.Conn,DM.MYSQL.Sqlquery);
            %CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name [(create_definition,...)][table_options] [select_statement]
            
        end
    end
    methods
        % core
        function DM=DSMYSQLEXEC(DM,varargin)
            if isempty(DM.MYSQL.Sqlquery)
                DM.MYSQL.Sqlquery=input('DM.MYSQL.Sqlquery:','s');
            end
            disp(DM.MYSQL.Sqlquery);
            
            exec(DM.MYSQL.Conn,DM.MYSQL.Sqlquery);
            DM.MYSQL.Curs = fetch(exec(DM.MYSQL.Conn,DM.MYSQL.Sqlquery));
            DM.MYSQL.Result=DM.MYSQL.Curs.Data;
            DM.MYSQL.Result
            DM.MES.Str=['your sql query is:',DM.MYSQL.Result];
            notify(DM,'QAMessage');
        end
        
    end
end
