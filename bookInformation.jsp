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
	<script type="text/javascript" src="jqeasyui/datagrid-detailview.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id='main' class="easyui-layout" data-options="fit:'true'" style="margin:0px 0px 0px 0px;">
 	
</div>    
<script>
$(document).ready(function() {
	var pmyGrid1={};
	pmyGrid1.id='myGrid1';
	pmyGrid1.parent='main';
	pmyGrid1.staticsql="select bookid as id,* from tobooks";
	pmyGrid1.activesql=pmyGrid1.staticsql;
	pmyGrid1.keyfield='bookid';
	pmyGrid1.pagesize=10;
	pmyGrid1.rowindex=-1;
	var xcolumns=[[
		{ title: '图书编码', field:'bookid', width: 80, halign:'center', align: 'left' },
		{ title: '书名', field:'bookname', width: 220, halign:'center', align: 'left' },
		{ title: '出版社', field:'pressname', width: 180, halign:'center', align: 'left' },
		{ title: '作者', field:'writer', width: 100, halign:'center', align: 'left' }
	]];
	var xfixedcolumns=[[
		{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'}
	]];
	var str='<div id="myGrid1" class="easyui-datagrid"></div>';
	$("#main").append($(str));
	$("#myGrid1").datagrid({
		title: '&nbsp;图书列表',
		iconCls: "panelIcon",
		width:800,
		height:555,
		nowrap: true,
		pagePosition: 'bottom',  //top,both
		autoRowHeight: false,
		rownumbers: false,
		pagination: true,
		pageSize: 10,
		pageNumber:1,
		striped: true,
		collapsible: true,
		singleSelect: true, //false,
		//idField: 'productid',
		frozenColumns: xfixedcolumns,
		columns: xcolumns,
		view: detailview,
		detailFormatter:function(index,row){    
			return '<div id="myForm' + index + '" style="position:relative; padding:5px 0"></div>';
		},    
		onExpandRow: function(index,row){
			//同一页只能同时展开一行
			if(pmyGrid1.rowindex>=0 && pmyGrid1.rowindex!=index) $('#myGrid1').datagrid('collapseRow',pmyGrid1.rowindex);
			pmyGrid1.rowindex=index;
			//设置div容器的属性
			$('#myForm'+index).panel({    
				border:true,
				//title:'商品详细信息',    
				cache:false, 
				height:140, 
				width:'100%',  //655
				onLoad:function(){    
					$('#myGrid1').datagrid('fixDetailRowHeight',index);    
				}    
			});    
        	$('#myGrid1').datagrid('fixDetailRowHeight',index);    
			//var sql="select * from products where productid='"+row.productid+"'";
			//var data=myRunSelectSql(sysdatabasestring, sql);
			//删除myFieldset1和myFieldset2控件，其容器内的所有控件也同时被删除
			if ($("#myFieldset1").length>0) $("#myFieldset1").remove();
			//if ($("#myFieldset2").length>0) $("#myFieldset2").remove();
			//添加两个容器控件，其类型为fieldset，没有border
			myGroupbox('myFieldset1','myForm'+index,0,0,0,0); 
			myGroupbox('myFieldset2','myForm'+index,0,0,0,0);
			//在容器内添加文字label控件显示商品信息。 
			//myLabelField(id,parent,label,top,left,height,width)
			myLabelField('bookid','myFieldset1','图书编码：'+row.bookid,25*0+10,12,0,120);
			myLabelField('bookname','myFieldset1','书名：'+row.bookname,25*1+10,12,0,0);
			myLabelField('pressname','myFieldset1','出版社：'+row.pressname,25*2+10,12,0,0);
			myLabelField('writer','myFieldset1','作者：'+row.writer,25*3+10,12,0,220);
			//添加一个图形控件，显示商品jpg图片
    	}    
	});
	
		
	//定义分页栏模式
	var pg = $("#myGrid1").datagrid("getPager");  
	pg.pagination({  
		//layout:['list','sep','first','prev','sep',$('#p-style').val(),'sep','next','last','sep','refresh'],
		showPageList: false,  //是否显示设置每页显示行数的下拉框
		beforePageText: '第', //页数文本框前显示的汉字  
		afterPageText: '页    共 {pages} 页', 
		displayMsg: '当前显示{from}～{to}行，共{total}行',
		onRefresh:function(pageNumber,pageSize){
			pmyGrid1.rowindex=0;  
			myLoadGridData(pmyGrid1,pageNumber);
		},  
		onChangePageSize:function(pageSize){  
			var opts = $('#myGrid1').datagrid('options');
			opts.pageSize=pageSize;		
			pmyGrid1.rowindex=0;		
			myLoadGridData(pmyGrid1,pageNumber);
		},  
		onSelectPage:function(pageNumber,pageSize){  
			var opts = $('#myGrid1').datagrid('options');
			opts.pageNumber=pageNumber;
			opts.pageSize=pageSize;		
			pmyGrid1.rowindex=0;		
			myLoadGridData(pmyGrid1,pageNumber);  
		}  
	}); 		  
	//初始化，显示第一页记录
	var opts = $("#myGrid1").datagrid('options');
	myLoadGridData(pmyGrid1,1);
//---------------------endofjquery----------------
});
</script>
</body>
</html>