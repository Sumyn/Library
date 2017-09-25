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
		sql_tobooks="select bookid+' '+bookname as text,* from tobooks";
		var xcolumns=[[
			{ title: '书名', field:'bookname', width: 160, halign:'center', align: 'left' },
			{ title: '出版社', field:'pressname', width: 200, halign:'center', align: 'left' },
			{ title: '作者', field:'writer', width: 110, halign:'center', align: 'left' },
			{ title: '借出状态', field:'lendout', width: 90, halign:'center', align: 'center' }
		]];
		var str='<table id="myTreeGrid1" class="easyui-treegrid" style="overflow:auto"></table>';
		$("#main").append($(str));
		trGrid=$("#myTreeGrid1");
		myMenu('myMenu1','新增节点/mnadd/addIcon;新增子节点/mnaddsub/addIcon;修改节点/mnedit/editIcon;-;删除/mndelete/deleteIcon;-;刷新/mnrefresh/refreshIcon','');
		trGrid.treegrid({
			title: '&nbsp;图书分类列表',
			iconCls: "panelIcon",
			width:800,
            height:'100%', //282, //'100%',
            collapsible: false,
            singleSelect:true,
            rownumbers: true,
			treeField: 'bookid',
            idField: 'id',
			frozenColumns:[[{ title: '图书编码', field:'bookid', width: 120, halign:'center', align: 'left' }]],
			columns: xcolumns,
							
		});	
		
		myButton("lend","main",'借书',2,260,24,70,'','');
		myButton("detail","main",'图书详情',2,360,24,120,'','');
		//定义窗口及其编辑控件
		//myWindow(id,title,top,left,height,width,buttons,style)
		myWindow('myEditWin1','编辑图书',30,0,350,400,'modal;drag');
		myFieldset('myFieldset1','myEditWin1','图书信息',10,10,200,350);
		myTextField('bookid','myFieldset1','图书编码：',70,36*0+20,18,0,160,'');
		myTextField('bookname','myFieldset1','书名：',70,36*1+20,18,0,160,'');
		myTextField('pressname','myFieldset1','出版社：',70,36*2+20,18,0,160,'');
		myTextField('writer','myFieldset1','作者：',70,36*3+20,18,0,160,'');
		myTextField('lendout','myFieldset1','借出状态：',70,36*4+20,18,0,160,'');
		myHiddenFields("addoredit;level;parentnodeid;ancester");  //隐藏用作变量	
		myButton("sure","myEditWin1",'确定',240,200,24,70,'','');
		myButton("cancel","myEditWin1",'取消',240,271,24,70,'','');
			
		 //调用通用函数，实现聚焦时全选文本框
		 mySelectOnFocus();
		////调用通用函数，下列各列实现键盘光标上下移动聚焦	
		//提取TreeGrid1第一层节点
		var sqlx="select * from ("+sql_tobooks+") as p where parentnodeid=''";  //第一层
		$.ajax({
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'bookid', sortfield:''}, 
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
				var sql=sql_tobooks;
				var sqlx="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
				var child_node = trGrid.treegrid('getChildren', pid);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'bookid', sortfield:'' }, 
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
		

		$('#lend').bind('click',function(item){
		   //$("#addoredit").val('edit');
			var records=trGrid.treegrid("getSelections");
			if (records.length>0){
				var pnode=trGrid.treegrid("getParent",records[0].id); //取其父节点
				if (pnode!=null){
					var parentstr=pnode.bookid+'-'+pnode.bookname;
					$("#myEditWin1").window('setTitle','借书【所属类别：'+parentstr+'】');
				}else{
					$("#myEditWin1").window('setTitle','借书【所属类别：无】');
				}
				//trGrid.treegrid('select','_'+pnode.id);
				$("#bookid").textbox("setValue",records[0].bookid);
				$("#bookname").textbox("setValue",records[0].bookname);
				$("#pressname").textbox("setValue",records[0].pressname);
				$("#writer").textbox("setValue",records[0].writer);
				$("#lendout").textbox("setValue",records[0].lendout);
				$("#bookid").textbox("readonly",true);  
				$("#bookname").textbox("readonly",true);
				$("#pressname").textbox("readonly",true);
				$("#writer").textbox("readonly",true);
				$("#lendout").textbox("readonly",true);
				$("#myEditWin1").window("open");
			}			
		});
		
		$("#cancel").bind('click', function(e){//点击取消按钮
			$("#myEditWin1").window('close');//点击取消按钮后窗口关闭
		});
		
		$("#sure").bind('click', function(e){ fnRefresh(e); });
		$("#detail").on('click',function(e){
		    fnbooks(e);
		  });
			
		
	//---------------------endofjquery
	});
	
	
	function fnRefresh(){
	    //alert(9);
	    var s1=$("#bookid").textbox('getValue');
	   // var s2=$("#lendout").textbox('getValue');
	    var sqlx="select * from tobooks where bookid='"+s1+"' and lendout='已借出'";
		var result=myRunSelectSql(sysdatabasestring,sqlx);  //调用函数myRunSelectSql把值赋给result
		if (result.length!=0){
			alert('该书已被借出！');
		}else{
		
	        var sql="update tobooks  set lendout='已借出' where bookid='"+$("#bookid").textbox('getValue')+"'";
    	    var result=myRunUpdateSql(sysdatabasestring,sql);
    	    }
    	//alert(sql);
    	$("#myEditWin1").window('close');
    	
    	
    }
    
    function fnbooks(){
        var url="http://127.0.0.1:8088/jQDemos/bookInformation.jsp";
        window.location.href=url;    
    }
		
</script>
</body>
</html>
