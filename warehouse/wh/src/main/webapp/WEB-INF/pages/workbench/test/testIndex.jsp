
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        $(function(){
            //给"创建"按钮添加单击事件
            $("#createActivityBtn").click(function () {

                //初始化工作
                //重置表单
                if("${sessionScope.sessionUser.userPerm}"=="3" || "${sessionScope.sessionUser.userPerm}"=="2"){
                    alert("权限不足");
                }else{
                    $("#createActivityForm").get(0).reset();

                    //弹出创建市场活动的模态窗口
                    $("#createActivityModal").modal("show");
                }

            });

            //给"保存"按钮添加单击事件
            $("#saveCreateActivityBtn").click(function () {
                //收集参数
                var typeName=$.trim($("#create-marketActivityName").val());
                var proColor=$("#create-color").prop('checked');
                var proCapacity=$("#create-capacity").prop('checked');
                var proDiameterBody=$("#create-diameter-body").prop('checked');
                var proHeight=$("#create-height").prop('checked');
                var proDiameterOutside=$("#create-diameter-outside").prop('checked');
                var proDiameterInside=$("#create-diameter-inside").prop('checked');
                var proContour=$("#create-contour").prop('checked');
                var proMaterial=$("#create-material").prop('checked');
                var proStock=$("#create-stock").prop('checked');
                var proRemarks=$("#create-remarks").prop('checked');
                //表单验证
                if(typeName==""){
                    alert("名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:'workbench/test/insertTypeInf.do',
                    data:{
                        typeName:typeName,
                        proColor:proColor,
                        proCapacity:proCapacity,
                        proHeight:proHeight,
                        proDiameterBody:proDiameterBody,
                        proDiameterOutside:proDiameterOutside,
                        proDiameterInside:proDiameterInside,
                        proContour:proContour,
                        proMaterial:proMaterial,
                        proStock:proStock,
                        proRemarks:proRemarks
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                            //刷新市场活动列，显示第一页数据，保持每页显示条数不变
                            queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭
                            $("#createActivityModal").modal("show");//可以不写。
                        }
                    }
                });
            });

            //当容器加载完成之后，对容器调用工具函数
            //$("input[name='mydate']").datetimepicker({
            $(".mydate").datetimepicker({
                language:'zh-CN', //语言
                format:'yyyy-mm-dd',//日期的格式
                minView:'month', //可以选择的最小视图
                initialDate:new Date(),//初始化显示的日期
                autoclose:true,//设置选择完日期或者时间之后，日否自动关闭日历
                todayBtn:true,//设置是否显示"今天"按钮,默认是false
                clearBtn:true//设置是否显示"清空"按钮，默认是false
            });

            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
            queryActivityByConditionForPage(1,10);

            //给"查询"按钮添加单击事件
            $("#queryActivityBtn").click(function () {
                //查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
                queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
            });

            //给"全选"按钮添加单击事件
            $("#chckAll").click(function () {
                //如果"全选"按钮是选中状态，则列表中所有checkbox都选中
                /*if(this.checked==true){
                    $("#tBody input[type='checkbox']").prop("checked",true);
                }else{
                    $("#tBody input[type='checkbox']").prop("checked",false);
                }*/

                $("#tBody input[type='checkbox']").prop("checked",this.checked);
            });

            /*$("#tBody input[type='checkbox']").click(function () {
                //如果列表中的所有checkbox都选中，则"全选"按钮也选中
                if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                    $("#chckAll").prop("checked",true);
                }else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
                    $("#chckAll").prop("checked",false);
                }
            });*/
            $("#tBody").on("click","input[type='checkbox']",function () {
                //如果列表中的所有checkbox都选中，则"全选"按钮也选中
                if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                    $("#chckAll").prop("checked",true);
                }else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
                    $("#chckAll").prop("checked",false);
                }
            });

            //给"删除"按钮添加单击事件
            $("#deleteActivityBtn").click(function () {
                if("${sessionScope.sessionUser.userPerm}"=="3" || "${sessionScope.sessionUser.userPerm}"=="2"){
                    alert("权限不足");
                    return;
                }
                //收集参数
                //获取列表中所有被选中的checkbox
                var chekkedIds=$("#tBody input[type='checkbox']:checked");
                if(chekkedIds.size()==0){
                    alert("请选择要删除的市场活动");
                    return;
                }

                if(window.confirm("确定删除吗？")){
                    var typeName;
                    $.each(chekkedIds,function () {//id=xxxx&id=xxx&.....&id=xxx&
                        typeName=this.value;
                        $.ajax({
                            url:'workbench/test/deleteTypeInf.do',
                            data:{
                                typeName:typeName
                            },
                            type:'post',
                            dataType:'json',
                            success:function (data) {
                                if(data.code=="1"){
                                    //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                    queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                                }else{
                                    //提示信息
                                    alert(data.message);
                                }
                            }
                        });
                    });
                    //typeIds=typeIds.substr(0,typeIds.length-1);//id=xxxx&id=xxx&.....&id=xxx

                    //发送请求

                }
            });

            //给"修改"按钮添加单击事件
            $("#editActivityBtn").click(function () {
                //收集参数
                //获取列表中被选中的checkbox
                var chkedIds=$("#tBody input[type='checkbox']:checked");
                if(chkedIds.size()==0){
                    alert("请选择要修改的市场活动");
                    return;
                }
                if(chkedIds.size()>1){
                    alert("每次只能修改一条市场活动");
                    return;
                }
                //var id=chkedIds.val();
                //var id=chkedIds.get(0).value;
                var typeName=chkedIds[0].value;
                //发送请求
                $.ajax({
                    url:'workbench/test/selectDataByTypeId.do',
                    data:{
                        typeName:typeName
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        //把市场活动的信息显示在修改的模态窗口上
                        $("#edit-typeName").val(typeName);
                        $("#edit-color").prop('checked',data.proColor=="1"?true:false);
                        $("#edit-capacity").prop('checked',data.proCapacity=="1"?true:false);
                        $("#edit-height").prop('checked',data.proHeight=="1"?true:false);
                        $("#edit-diameter-body").prop('checked',data.proDiameterBody=="1"?true:false);
                        $("#edit-diameter-outside").prop('checked',data.proDiameterOutside=="1"?true:false);
                        $("#edit-diameter-inside").prop('checked',data.proDiameterInside=="1"?true:false);
                        $("#edit-contour").prop('checked',data.proContour=="1"?true:false);
                        $("#edit-material").prop('checked',data.proMaterial=="1"?true:false);
                        $("#edit-stock").prop('checked',data.proStock=="1"?true:false);
                        $("#edit-remarks").prop('checked',data.proRemarks=="1"?true:false);
                        //弹出模态窗口
                        $("#editActivityModal").modal("show");
                    }
                });
            });

            //给"更新"按钮添加单击事件
            $("#saveEditActivityBtn").click(function () {
                if("${sessionScope.sessionUser.userPerm}"=="3"){
                    alert("权限不足");
                    return;
                }

                //收集参数
                var typeName=$.trim($("#edit-typeName").val());
                var proColor=$("#edit-color").prop('checked');
                var proCapacity=$("#edit-capacity").prop('checked');
                var proDiameterBody=$("#edit-diameter-body").prop('checked');
                var proHeight=$("#edit-height").prop('checked');
                var proDiameterOutside=$("#edit-diameter-outside").prop('checked');
                var proDiameterInside=$("#edit-diameter-inside").prop('checked');
                var proContour=$("#edit-contour").prop('checked');
                var proMaterial=$("#edit-material").prop('checked');
                var proStock=$("#edit-stock").prop('checked');
                var proRemarks=$("#edit-remarks").prop('checked');
                //表单验证(作业)

                //发送请求
                $.ajax({
                    url:'workbench/test/updateByTypeId.do',
                    data:{
                        typeName:typeName,
                        proColor:proColor,
                        proCapacity:proCapacity,
                        proHeight:proHeight,
                        proDiameterBody:proDiameterBody,
                        proDiameterOutside:proDiameterOutside,
                        proDiameterInside:proDiameterInside,
                        proContour:proContour,
                        proMaterial:proMaterial,
                        proStock:proStock,
                        proRemarks:proRemarks
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            alert(data.message);
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");
                            //刷新市场活动列表,保持页号和每页显示条数都不变
                            queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭
                            $("#editActivityModal").modal("show");
                        }
                    }
                });
            });

            //给"批量导出"按钮添加单击事件
            $("#exportActivityAllBtn").click(function () {
                //发送同步请求
                window.location.href="workbench/activity/exportAllActivitys.do";
            });

            //给"导入"按钮添加单击事件
            $("#importActivityBtn").click(function () {
                //收集参数
                var activityFileName=$("#activityFile").val();
                var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();//xls,XLS,Xls,xLs,....
                if(suffix!="xls"){
                    alert("只支持xls文件");
                    return;
                }
                var activityFile=$("#activityFile")[0].files[0];
                if(activityFile.size>5*1024*1024){
                    alert("文件大小不超过5MB");
                    return;
                }

                //FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
                //FormData最大的优势是不但能提交文本数据，还能提交二进制数据
                var formData=new FormData();
                formData.append("activityFile",activityFile);
                formData.append("userName","张三");

                //发送请求
                $.ajax({
                    url:'workbench/activity/importActivity.do',
                    data:formData,
                    processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
                    contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
                    type:'post',
                    dataType:'json',
                    success:function (data) {
                        if(data.code=="1"){
                            //提示成功导入记录条数
                            alert("成功导入"+data.retData+"条记录");
                            //关闭模态窗口
                            $("#importActivityModal").modal("hide");
                            //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                            queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        }else{
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭
                            $("#importActivityModal").modal("show");
                        }
                    }
                });
            });
        });

        function queryActivityByConditionForPage(pageNo,pageSize) {
            $.ajax({
                url:'workbench/getTypeName.do',
                type:'post',
                dataType:'json',
                data: {
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                success:function (data) {
                    //显示总条数
                    //$("#totalRowsB").text(data.totalRows);
                    //显示市场活动的列表
                    //遍历activityList，拼接所有行数据
                    var htmlStr="";
                    $.each(data.list,function (index,obj) {
                        htmlStr+="<tr class=\"active\">";
                        htmlStr+="<td><input type=\"checkbox\" value=\""+obj.typeName+"\"/></td>";
                        htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.typeId+"'\">"+obj.typeId+"</a></td>";
                        htmlStr+="<td>"+obj.typeName+"</td>";
                        // htmlStr+="<td>"+obj.startDate+"</td>";
                        // htmlStr+="<td>"+obj.endDate+"</td>";
                        htmlStr+="</tr>";
                    });
                    $("#tBody").html(htmlStr);

                    //取消"全选"按钮
                    $("#chckAll").prop("checked",false);

                    //计算总页数
                    var totalPages=1;
                    if(data.totalRows%pageSize==0){
                        totalPages=data.totalRows/pageSize;
                    }else{
                        totalPages=parseInt(data.totalRows/pageSize)+1;
                    }

                    //对容器调用bs_pagination工具函数，显示翻页信息
                    $("#demo_pag1").bs_pagination({
                        currentPage:pageNo,//当前页号,相当于pageNo

                        rowsPerPage:pageSize,//每页显示条数,相当于pageSize
                        totalRows:data.totalRows,//总条数
                        totalPages: totalPages,  //总页数,必填参数.

                        visiblePageLinks:5,//最多可以显示的卡片数

                        showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
                        showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
                        showRowsInfo:true,//是否显示记录的信息，默认true--显示

                        //用户每次切换页号，都自动触发本函数;
                        //每次返回切换页号之后的pageNo和pageSize
                        onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
                            //js代码
                            //alert(pageObj.currentPage);
                            //alert(pageObj.rowsPerPage);
                            queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">添加新的类型</h4>
            </div>
            <div class="modal-body">
                <p>
                    选择类型的属性<br>
                    备注：体直径，单位是mm，一般指瓶身直径、瓶盖外直径等<br>
                    瓶口外径，单位是mm，一般指瓶口的外部直径<br>
                    瓶口内径，单位是mm，一般指瓶口的内部直径，或瓶盖的内部直径等<br>
                </p>
                <form id="createActivityForm" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="create-marketActivityName" class="col-sm-2 control-label">产品类型<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-color" class="col-sm-2 control-label">产品颜色</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-color">
                        </div>
                        <label for="create-capacity" class="col-sm-2 control-label">产品容量</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-capacity">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-height" class="col-sm-2 control-label">产品高度</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-height">
                        </div>
                        <label for="create-diameter-body" class="col-sm-2 control-label">体直径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-diameter-body">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-diameter-outside" class="col-sm-2 control-label">瓶口外径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-diameter-outside">
                        </div>
                        <label for="create-diameter-inside" class="col-sm-2 control-label">瓶口内径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-diameter-inside">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-contour" class="col-sm-2 control-label">产品外形</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-contour">
                        </div>
                        <label for="create-material" class="col-sm-2 control-label">材料</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-material">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-stock" class="col-sm-2 control-label">产品库存</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-stock">
                        </div>
                        <label for="create-remarks" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="create-remarks">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改产品类型</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-typeName" class="col-sm-2 control-label">产品类型<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-typeName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-color" class="col-sm-2 control-label">产品颜色</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-color">
                        </div>
                        <label for="edit-capacity" class="col-sm-2 control-label">产品容量</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-capacity">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-height" class="col-sm-2 control-label">产品高度</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-height">
                        </div>
                        <label for="edit-diameter-body" class="col-sm-2 control-label">体直径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-diameter-body">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-diameter-outside" class="col-sm-2 control-label">瓶口外径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-diameter-outside">
                        </div>
                        <label for="edit-diameter-inside" class="col-sm-2 control-label">瓶口内径</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-diameter-inside">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-contour" class="col-sm-2 control-label">产品外形</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-contour">
                        </div>
                        <label for="edit-material" class="col-sm-2 control-label">材料</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-material">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-stock" class="col-sm-2 control-label">产品库存</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-stock">
                        </div>
                        <label for="edit-remarks" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 50px;height: 5px;">
                            <input type="checkbox" class="form-control" id="edit-remarks">
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditActivityBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>产品类型列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">


        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-default" id="queryActivityBtn"><span class="glyphicon glyphicon-import"></span>获取</button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="chckAll"/></td>
                    <td>类型编号</td>
                    <td>类型名称</td>
<%--                    <td>开始日期</td>--%>
<%--                    <td>结束日期</td>--%>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--						<tr class="active">--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detdetail.jsp>发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detdetail.jsp>发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>2020-10-10</td>--%>
                <%--                            <td>2020-10-20</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

<%--        			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--        				<div>--%>
<%--        					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
<%--        				</div>--%>
<%--        				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--        					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--        					<div class="btn-group">--%>
<%--        						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--        							10--%>
<%--        							<span class="caret"></span>--%>
<%--        						</button>--%>
<%--        						<ul class="dropdown-menu" role="menu">--%>
<%--        							<li><a href="#">20</a></li>--%>
<%--        							<li><a href="#">30</a></li>--%>
<%--        						</ul>--%>
<%--        					</div>--%>
<%--        					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--        				</div>--%>
<%--        				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--        					<nav>--%>
<%--        						<ul class="pagination">--%>
<%--        							<li class="disabled"><a href="#">首页</a></li>--%>
<%--        							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--        							<li class="active"><a href="#">1</a></li>--%>
<%--        							<li><a href="#">2</a></li>--%>
<%--        							<li><a href="#">3</a></li>--%>
<%--        							<li><a href="#">4</a></li>--%>
<%--        							<li><a href="#">5</a></li>--%>
<%--        							<li><a href="#">下一页</a></li>--%>
<%--        							<li class="disabled"><a href="#">末页</a></li>--%>
<%--        						</ul>--%>
<%--        					</nav>--%>
<%--        				</div>--%>
<%--        			</div>--%>

    </div>

</div>
</body>
</html>