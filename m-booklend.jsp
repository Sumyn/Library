<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id='main' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
 	
</div>    
<script>
	$(document).ready(function() {
	
	   myButton("books","main",'书库',2,260,24,70,'','');
		$("#books").on('click',function(e){
		    fnbooks(e);
		  });
	
	
		sql_books="select id+' '+name as text,* from mybooks";
		var xcolumns=[[
			{ title: '姓名', field:'name', width: 160, halign:'center', align: 'left' }
		]];
		var str='<table id="myTreeGrid1" class="easyui-treegrid" style="overflow:auto"></table>';
		$("#main").append($(str));
		trGrid=$("#myTreeGrid1");
		trGrid.treegrid({
			title: '&nbsp;学生借书列表',
			iconCls: "panelIcon",
			width:600,
            height:'100%', //282, //'100%',
            collapsible: false,
            singleSelect:true,
            rownumbers: true,
			treeField: 'id',
            idField: 'id',
			frozenColumns:[[{ title: '学号', field:'id', width: 160, halign:'center', align: 'left' }]],
			columns: xcolumns				
		});	
		//提取TreeGrid1第一层节点
		var sqlx="select * from ("+sql_books+") as p where parentnodeid=''";  //第一层
		$.ajax({
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'id', sortfield:''}, 
			async: false, method: 'post',    
			success: function(data) {
				//console.log(data);     
				var source=eval(data);
				trGrid.treegrid({ data: source });  //加载json数据到树
			}    
		});
		//定义myTreeGrid1父节点 点击展开事件
		trGrid.treegrid({
			onBeforeExpand: function (node){  //点击展开事件
				var pid=node.id;
				//var sql=trGrid.attr('xsql');
				var sql=sql_books;
				var sqlx="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
				var child_node = trGrid.treegrid('getChildren', pid);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'id', sortfield:'' }, 
						async: false, method: 'post',    
						success: function(data) {
							var source=eval(data);
							trGrid.treegrid('remove', child_node[0].id); //删除虚拟子节点
							trGrid.treegrid('append', {  //增加数据作为子节点
								parent: pid, //这里不能用node.target,
								data: source 
							});
						}     
					});
				}
			},
			//双击展开或收缩结点事件	
			onDblClickRow: function(row){
				if (row.state=='closed') $(this).treegrid('expand', row.id);
				else $(this).treegrid('collapse', row.id);
			}
		});
		
		
	//---------------------endofjquery
	});
	
	function fnbooks(){
        var url="http://127.0.0.1:8088/jQDemos/2stutobooks.jsp";
        window.location.href=url;    
    }
	
</script>
</body>
</html>