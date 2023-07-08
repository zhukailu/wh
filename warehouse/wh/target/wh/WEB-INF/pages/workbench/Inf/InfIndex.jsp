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

        $(function() {
            //给"创建"按钮添加单击事件
            $("#createActivityBtn").click(function () {
                //初始化工作
                //重置表单
                //用户权限，0：root  1：可增加删除操作   2：可修改操作  3：只读
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
                var typeId = $.trim($("#create-typeName").val());
                var productName = $.trim($("#create-productName").val());
                var proColor = $.trim($("#create-color").val());
                var proCapacity = $.trim($("#create-capacity").val());
                var proDiameterBody = $.trim($("#create-diameter-body").val());
                var proHeight = $.trim($("#create-height").val());
                var proDiameterOutside = $.trim($("#create-diameter-outside").val());
                var proDiameterInside = $.trim($("#create-diameter-inside").val());
                var proMaterial = $.trim($("#create-material").val());
                var proStock = $.trim($("#create-stock").val());
                var proRemarks = $.trim($("#create-remarks").val());
                var proWeight = $.trim($("#create-weight").val());
                var proPackage = $.trim($("#create-package").val());
                var proNorms = $.trim($("#create-norms").val());
                var proBoxNum = $.trim($("#create-box-num").val());
                var proCargoNum = $.trim($("#create-cargo-num").val());
                if(proCapacity==''){
                    proCapacity=0;
                }
                if(proHeight==''){
                    proHeight=0;
                }
                if(proDiameterBody==''){
                    proDiameterBody=0;
                }
                if(proDiameterOutside==''){
                    proDiameterOutside=0;
                }
                if(proDiameterInside==''){
                    proDiameterInside=0;
                }
                if(proWeight==''){
                    proWeight=0;
                }
                //表单验证
                if (typeId == "") {
                    alert("名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: 'workbench/Inf/insertProductInf.do',
                    data: {
                        typeId: typeId,
                        productName: productName,
                        proColor: proColor,
                        proCapacity: proCapacity,
                        proHeight: proHeight,
                        proDiameterBody: proDiameterBody,
                        proDiameterOutside: proDiameterOutside,
                        proDiameterInside: proDiameterInside,
                        //proContour: proContour,
                        proMaterial: proMaterial,
                        proStock: proStock,
                        proRemarks: proRemarks,
                        proWeight:proWeight,
                        proPackage:proPackage,
                        proNorms:proNorms,
                        proBoxNum:proBoxNum,
                        proCargoNum:proCargoNum
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            updateImage();
                            //关闭模态窗口
                            if ($("#uploadImage")[0].files[0]==null){
                                alert(data.message);
                            }
                            $("#createActivityModal").modal("hide");
                            //刷新市场活动列，显示第一页数据，保持每页显示条数不变
                            queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
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
                language: 'zh-CN', //语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month', //可以选择的最小视图
                initialDate: new Date(),//初始化显示的日期
                autoclose: true,//设置选择完日期或者时间之后，日否自动关闭日历
                todayBtn: true,//设置是否显示"今天"按钮,默认是false
                clearBtn: true//设置是否显示"清空"按钮，默认是false
            });

            //当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
            queryActivityByConditionForPage(1, 10);

            //给"查询"按钮添加单击事件
            $("#queryActivityBtn").click(function () {
                //查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
            });

            //给"全选"按钮添加单击事件
            $("#chckAll").click(function () {
                //如果"全选"按钮是选中状态，则列表中所有checkbox都选中
                /*if(this.checked==true){
                    $("#tBody input[type='checkbox']").prop("checked",true);
                }else{
                    $("#tBody input[type='checkbox']").prop("checked",false);
                }*/

                $("#tBody input[type='checkbox']").prop("checked", this.checked);
            });

            /*$("#tBody input[type='checkbox']").click(function () {
                //如果列表中的所有checkbox都选中，则"全选"按钮也选中
                if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                    $("#chckAll").prop("checked",true);
                }else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
                    $("#chckAll").prop("checked",false);
                }
            });*/
            $("#tBody").on("click", "input[type='checkbox']", function () {
                //如果列表中的所有checkbox都选中，则"全选"按钮也选中
                if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {
                    $("#chckAll").prop("checked", true);
                } else {//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
                    $("#chckAll").prop("checked", false);
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
                var chekkedIds = $("#tBody input[type='checkbox']:checked");
                if (chekkedIds.size() == 0) {
                    alert("请选择要删除的市场活动");
                    return;
                }

                if (window.confirm("确定删除吗？")) {
                    var productId;
                    $.each(chekkedIds, function () {//id=xxxx&id=xxx&.....&id=xxx&
                        productId = this.value;
                        $.ajax({
                            url: 'workbench/Inf/deleteProductInf.do',
                            data: {
                                productId: productId
                            },
                            type: 'post',
                            dataType: 'json',
                            success: function (data) {
                                if (data.code == "1") {
                                    alert(data.message);
                                    //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                    queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
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
                var chkedIds = $("#tBody input[type='checkbox']:checked");
                if (chkedIds.size() == 0) {
                    alert("请选择要修改的市场活动");
                    return;
                }
                if (chkedIds.size() > 1) {
                    alert("每次只能修改一条市场活动");
                    return;
                }
                //var id=chkedIds.val();
                //var id=chkedIds.get(0).value;
                var productId = chkedIds[0].value;
                //发送请求
                $.ajax({
                    url: 'workbench/Inf/getDataByProductId.do',
                    data: {
                        productId: productId
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        //把市场活动的信息显示在修改的模态窗口上
                        $("#getProductId").val(productId);
                        $("#getProductId").text(productId);
                        $("#edit-productName").val(data.productName);
                        $("#edit-typeName").val(data.productTypeId);
                        $("#edit-color").val(data.productColor);
                        $("#edit-capacity").val(data.productCapacity);
                        $("#edit-height").val(data.productHeight);
                        $("#edit-diameter-body").val(data.productDiameterBody);
                        $("#edit-diameter-outside").val(data.productDiameterOutside);
                        $("#edit-diameter-inside").val(data.productDiameterInside);
                        //$("#edit-contour").val(data.productContour);
                        $("#edit-material").val(data.productMaterial);
                        $("#edit-stock").val(data.productStock);
                        $("#edit-remarks").val(data.productRemarks);
                        $("#edit-weight").val(data.productWeight);
                        $("#edit-package").val(data.productPackage);
                        $("#edit-norms").val(data.productNorms);
                        $("#edit-box-num").val(data.productBoxNum);
                        $("#edit-cargo-num").val(data.productCargoNum);

                        var htmlS="";
                        htmlS+="原图片<img src="+data.productContour+" height=\"150px\">";
                        $("#oldImage").html(htmlS);
                        var htmlStr="";
                        htmlStr+="<form action=\"workbench/Inf/getImage.do\" method=\"post\" enctype=\"multipart/form-data\" id=\"imageForm\">"
                        htmlStr+="<input type=\"file\" name=\"uploadFile\" multiple id=\"edit-Image\">产品图片<br/>";
                        htmlStr+="</form>";
                        $("#getNewImage").html(htmlStr);
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
                //表单验证(作业)
                var productId = $("#getProductId").val();
                var typeId = $.trim($("#edit-typeName").val());
                var productName = $.trim($("#edit-productName").val());
                var proColor = $.trim($("#edit-color").val());
                var proCapacity = $.trim($("#edit-capacity").val());
                var proDiameterBody = $.trim($("#edit-diameter-body").val());
                var proHeight = $.trim($("#edit-height").val());
                var proDiameterOutside = $.trim($("#edit-diameter-outside").val());
                var proDiameterInside = $.trim($("#edit-diameter-inside").val());
                //var proContour = $.trim($("#edit-contour").val());
                var proMaterial = $.trim($("#edit-material").val());
                var proStock = $.trim($("#edit-stock").val());
                var proRemarks = $.trim($("#edit-remarks").val());
                var proWeight = $.trim($("#edit-weight").val());
                var proPackage = $.trim($("#edit-package").val());
                var proNorms = $.trim($("#edit-norms").val());
                var proBoxNum = $.trim($("#edit-box-num").val());
                var proCargoNum = $.trim($("#edit-cargo-num").val());
                if(proCapacity==''){
                    proCapacity=0;
                }
                if(proHeight==''){
                    proHeight=0;
                }
                if(proDiameterBody==''){
                    proDiameterBody=0;
                }
                if(proDiameterOutside==''){
                    proDiameterOutside=0;
                }
                if(proDiameterInside==''){
                    proDiameterInside=0;
                }
                if(proWeight==''){
                    proWeight=0;
                }
                //发送请求
                $.ajax({
                    url: 'workbench/Inf/updateByproductId.do',
                    data: {
                        productId: productId,
                        typeId: typeId,
                        productName: productName,
                        proColor: proColor,
                        proCapacity: proCapacity,
                        proHeight: proHeight,
                        proDiameterBody: proDiameterBody,
                        proDiameterOutside: proDiameterOutside,
                        proDiameterInside: proDiameterInside,
                        proMaterial: proMaterial,
                        proStock: proStock,
                        proRemarks: proRemarks,
                        proWeight:proWeight,
                        proPackage:proPackage,
                        proNorms:proNorms,
                        proBoxNum:proBoxNum,
                        proCargoNum:proCargoNum
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            updateNewImage();
                            if ($("#edit-Image")[0].files[0]==null){
                                alert(data.message);
                            }
                            //alert(data.message);
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");
                            //刷新市场活动列表,保持页号和每页显示条数都不变
                            queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'), $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭
                            $("#editActivityModal").modal("show");
                        }
                    }
                });
            });

        });

            function updateImage(){
                var formData = new FormData();
                if ($("#uploadImage")[0].files[0]==null){
                    return;
                }
                formData.append("file", $("#uploadImage")[0].files[0]);
                $.ajax({
                    url: "workbench/Inf/getImage.do",
                    type: "post",
                    data: formData,
                    processData: false, // 告诉jQuery不要去处理发送的数据
                    contentType: false, // 告诉jQuery不要去设置Content-Type请求头
                    success: function(data) {
                        alert(data.message);
                    },
                    error: function(data) {

                    }
                });
            }

        function updateNewImage(){
            var formData = new FormData();
            if ($("#edit-Image")[0].files[0]==null){
                return;
            }
            formData.append("file", $("#edit-Image")[0].files[0]);
            $.ajax({
                url: "workbench/Inf/getImage.do",
                type: "post",
                data: formData,
                processData: false, // 告诉jQuery不要去处理发送的数据
                contentType: false, // 告诉jQuery不要去设置Content-Type请求头
                success: function(data) {
                    alert(data.message);
                },
                error: function(data) {
                }
            });
        }

            function queryActivityByConditionForPage(pageNo, pageSize) {
                //收集参数
                var name = $("#query-name").val();
                var type = $("#query-type").val();
                var color = $("#query-color").val();
                var material = $("#query-material").val();
                $.ajax({
                    url: 'workbench/Inf/getProductInf.do',
                    type: 'post',
                    dataType: 'json',
                    data: {
                        name: name,
                        type: type,
                        color: color,
                        material: material,
                        pageNo: pageNo,
                        pageSize: pageSize
                    },
                    success: function (data) {
                        /*<td><input type="checkbox" id="chckAll"/></td>
                    <td width="150px">产品图片</td>
                    <td width="100px">单品货号</td>
                    <td width="200px">产品名称</td>
                    <td width="80px">产品库存</td>
                    <td width="1200px">产品备注</td>*/
                        var htmlStr = "";
                        $.each(data.list, function (index, obj) {
                            htmlStr += "<tr class=\"active\">";
                            htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.productId + "\" /></td>";

                            htmlStr+='<td>';
                            htmlStr +=('<img src="'+obj.productContour+'" style="width: 100px; position: relative;">');
                            htmlStr+='</td>';

                            htmlStr += "<td>"+obj.productCargoNum+"</td>";
                            htmlStr += "<td>" + obj.productName + "</td>";
                            htmlStr += "<td>" + obj.productStock + "</td>";
                            htmlStr += "<td>" + obj.productCapacity + "</td>";
                            htmlStr += "<td>" + obj.productDiameterBody + "</td>";
                            htmlStr += "<td>" + obj.productHeight + "</td>";
                            htmlStr += "<td>" + obj.productWeight + "</td>";

                            htmlStr += "</tr>";
                        });
                        $("#tBody").html(htmlStr);

                        //取消"全选"按钮
                        $("#chckAll").prop("checked", false);

                        //计算总页数
                        var totalPages = 1;
                        if (data.totalRows % pageSize == 0) {
                            totalPages = data.totalRows / pageSize;
                        } else {
                            totalPages = parseInt(data.totalRows / pageSize) + 1;
                        }

                        //对容器调用bs_pagination工具函数，显示翻页信息
                        $("#demo_pag1").bs_pagination({
                            currentPage: pageNo,//当前页号,相当于pageNo

                            rowsPerPage: pageSize,//每页显示条数,相当于pageSize
                            totalRows: data.totalRows,//总条数
                            totalPages: totalPages,  //总页数,必填参数.

                            visiblePageLinks: 5,//最多可以显示的卡片数

                            showGoToPage: true,//是否显示"跳转到"部分,默认true--显示
                            showRowsPerPage: true,//是否显示"每页显示条数"部分。默认true--显示
                            showRowsInfo: true,//是否显示记录的信息，默认true--显示

                            //用户每次切换页号，都自动触发本函数;
                            //每次返回切换页号之后的pageNo和pageSize
                            onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                                //js代码
                                //alert(pageObj.currentPage);
                                //alert(pageObj.rowsPerPage);
                                queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
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
                <h4 class="modal-title" id="myModalLabel1">添加新的产品</h4>
            </div>
            <div class="modal-body">
                <p>
                    选择产品的属性填写<br>
                    其中，红色字体的属性表示需要填入数字，这些属性的单位是毫米/毫升/个
                    带*的属性表示必填
                    提示：体直径，单位是mm，一般指瓶身直径、瓶盖外直径等<br>
                        瓶口外径，单位是mm，一般指瓶口的外部直径<br>
                        瓶口内径，单位是mm，一般指瓶口的内部直径，或瓶盖的内部直径等<br>
                        备注区域建议填写产品的一些外形方面的细节特征，便于区分相似产品<br>
                        图片区域上传的图片大小不能超过50MB
                </p>
                <form action="workbench/Inf/getImage.do" method="post" enctype="multipart/form-data">
                    产品图片<input type="file" name="uploadFile" multiple id="uploadImage"><br/>
                </form>
                <form id="createActivityForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-productName" class="col-sm-2 control-label">产品名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-productName">
                        </div>

                        <label for="create-typeName" class="col-sm-2 control-label">产品类型<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-typeName">
                                <c:forEach items="${typeList}" var="t">
                                    <option value="${t.typeId}">${t.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-cargo-num" class="col-sm-2 control-label">货单编号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cargo-num">
                        </div>
                    </div>
                    <div class="form-group" id="colorAndCapacity">
                        <label for="create-color" class="col-sm-2 control-label">产品颜色</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-color">
                        </div>
                        <label for="create-capacity" class="col-sm-2 control-label"><span style="color: red;">产品容量</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-capacity">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-diameter-outside" class="col-sm-2 control-label"><span style="color: red;">瓶口外径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-diameter-outside">
                        </div>
                        <label for="create-diameter-inside" class="col-sm-2 control-label"><span style="color: red;">瓶口内径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-diameter-inside">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-diameter-body" class="col-sm-2 control-label"><span style="color: red;">体直径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-diameter-body">
                        </div>
                        <label for="create-height" class="col-sm-2 control-label"><span style="color: red;">产品高度</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-height">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-weight" class="col-sm-2 control-label"><span style="color: red;">产品重量</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-weight">
                        </div>
                        <label for="create-material" class="col-sm-2 control-label">材料</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-material">
                        </div>

                    </div>
                    <div class="form-group">
                        <label for="create-stock" class="col-sm-2 control-label"><span style="color: red;">产品库存</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-stock">
                        </div>
                        <label for="create-package" class="col-sm-2 control-label">包装方式</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-package">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-norms" class="col-sm-2 control-label">箱规尺寸</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-norms">
                        </div>
                        <label for="create-box-num" class="col-sm-2 control-label">每箱数量</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-box-num">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-remarks" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 800px;">
<%--                            <input type="text" class="form-control" id="create-remarks">--%>
                            <textarea class="form-control" rows="3" id="create-remarks"></textarea>
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
                <h4 class="modal-title" id="myModalLabel2">修改产品信息</h4>
                产品编号<button type="button" id="getProductId"></button>
            </div>

            <div class="modal-body">
                <div id="oldImage">

                </div>
                <div id="getNewImage">


                </div>
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-productName" class="col-sm-2 control-label">产品名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-productName">
                        </div>
                        <label for="edit-typeName" class="col-sm-2 control-label">产品类型<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-typeName">
                                <c:forEach items="${typeList}" var="t">
                                    <option value="${t.typeId}">${t.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-cargo-num" class="col-sm-2 control-label">货单编号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cargo-num">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-color" class="col-sm-2 control-label">产品颜色</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-color">
                        </div>
                        <label for="edit-capacity" class="col-sm-2 control-label"><span style="color: red;">产品容量</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-capacity">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-diameter-outside" class="col-sm-2 control-label"><span style="color: red;">瓶口外径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-outside">
                        </div>
                        <label for="edit-diameter-inside" class="col-sm-2 control-label"><span style="color: red;">瓶口内径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-inside">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-diameter-body" class="col-sm-2 control-label"><span style="color: red;">体直径</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-body">
                        </div>
                        <label for="edit-height" class="col-sm-2 control-label"><span style="color: red;">产品高度</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-height">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-weight" class="col-sm-2 control-label"><span style="color: red;">产品重量</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-weight">
                        </div>
                        <label for="edit-material" class="col-sm-2 control-label">材料</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-material">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-stock" class="col-sm-2 control-label"><span style="color: red;">产品库存</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-stock">
                        </div>
                        <label for="edit-package" class="col-sm-2 control-label">包装方式</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-package">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-norms" class="col-sm-2 control-label">箱规尺寸</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-norms">
                        </div>
                        <label for="edit-box-num" class="col-sm-2 control-label">每箱数量</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-box-num">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-remarks" class="col-sm-2 control-label">备注</label>
                        <div class="col-sm-10" style="width: 600px;">
<%--                            <input type="text" class="form-control" id="edit-remarks">--%>
                            <textarea class="form-control" rows="3" id="edit-remarks"></textarea>
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
            <h3>产品信息列表</h3>
        </div>
    </div>
</div>


<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" >
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <input class="form-control" type="text" id="query-type">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">颜色</div>
                        <input class="form-control" type="text" id="query-color" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">材料</div>
                        <input class="form-control" type="text" id="query-material">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>

            </form>
        </div>

        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-detail" id="detailActivityBtn"><span class="glyphicon glyphicon-import"></span> 详细</button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="chckAll" /></td>
                    <td>产品图片</td>
                    <td>单品货号</td>
                    <td>产品名称</td>
                    <td>产品库存</td>
                    <td>产品容量</td>
                    <td>产品直径</td>
                    <td>产品高度</td>
                    <td>产品重量</td>
                    <!-- width="100px"-->
                    <!-- width="150px"-->
                    <!-- width="200px"-->
                    <!-- width="100px"-->
                    <!-- width="100px"-->
                    <!-- width="100px"-->
                    <!-- width="100px"-->
                    <!-- width="100px"-->
                    <%--                    <td>开始日期</td>--%>
                    <%--                    <td>结束日期</td>--%>
                </tr>
                </thead>
                <tbody id="tBody">

                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>



    </div>

</div>
</body>
</html>