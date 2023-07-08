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
            $("#input—operate").click(function () {
                if("${sessionScope.sessionUser.userPerm}"=="3"){
                    alert("权限不足");
                    return;
                }
                var chekkedIds = $("#tBody input[type='checkbox']:checked");
                if (chekkedIds.size() == 0) {
                    alert("请选择要修改的市场活动");
                    return;
                }
                if (chekkedIds.size() > 1) {
                    alert("每次只能修改一条市场活动");
                    return;
                }
                //初始化工作
                //重置表单
                $("#createActivityForm").get(0).reset();
                //设置类型为入库 create-operateName
                $("#create-operateName").val("入库");

                var productId=chekkedIds[0].value;
                $.ajax({
                    url:"workbench/Inf/getDataByProductId.do",
                    data: {
                        productId:productId
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        $("#create-productName").val(data.productName);
                    }
                });
                //弹出创建市场活动的模态窗口
                $("#createActivityModal").modal("show");
            });

            $("#output—operate").click(function () {
                if("${sessionScope.sessionUser.userPerm}"=="3"){
                    alert("权限不足");
                    return;
                }
                var chekkedIds = $("#tBody input[type='checkbox']:checked");
                if (chekkedIds.size() == 0) {
                    alert("请选择要修改的市场活动");
                    return;
                }
                if (chekkedIds.size() > 1) {
                    alert("每次只能修改一条市场活动");
                    return;
                }
                //初始化工作
                //重置表单
                $("#createActivityForm").get(0).reset();
                //设置类型为入库
                $("#create-operateName").val("出库");
                var productId=chekkedIds[0].value;
                $.ajax({
                    url:"workbench/Inf/getDataByProductId.do",
                    data: {
                        productId:productId
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        $("#create-productName").val(data.productName);
                    }
                });
                //弹出创建市场活动的模态窗口
                $("#createActivityModal").modal("show");
            });

            //给"保存"按钮添加单击事件
            <%--        产品名称create-productName
            操作类型create-operateName
            数量create-operateNum
            操作人create-operateUser
            备注create-remarks
    --%>
            $("#saveCreateActivityBtn").click(function () {
                var chekkedIds = $("#tBody input[type='checkbox']:checked");

                //收集参数
                var operateProductName =$.trim($("#create-productName").val());
                var operateType = $.trim($("#create-operateName").val());
                var operateNum = $.trim($("#create-operateNum").val());
                var operateUserName = $.trim($("#create-operateUser").val());
                var operateRemarks = $.trim($("#create-remarks").val());
                var userId=${sessionScope.sessionUser.userId};
                var productId=chekkedIds[0].value;
                if(operateNum==""){
                    alert("数量不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: 'workbench/operate/insertOperateInf.do',
                    data: {
                        operateProductName:operateProductName,
                        operateType:operateType,
                        operateNum:operateNum,
                        operateUserName:operateUserName,
                        operateRemarks:operateRemarks,
                        userId:userId,
                        productId:productId
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            alert(data.message);
                            //关闭模态窗口
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
                        htmlS+="<img src="+data.productContour+" width=\"150px\">";
                        $("#oldImage").html(htmlS);
                        //弹出模态窗口
                        $("#editActivityModal").modal("show");
                    }
                });
            });


        });

        function updateImage(){
            var formData = new FormData();
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
                    var htmlStr = "";
                    $.each(data.list, function (index, obj) {
                        htmlStr += "<tr class=\"active\">";
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.productId + "\"/></td>";

                        htmlStr+='<td>';
                        htmlStr +=('<img src="'+obj.productContour+'" style="width: 100px; position: relative;">');
                        htmlStr+='</td>';

                        htmlStr += "<td>" + obj.productCargoNum + "</td>";
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
                <h4 class="modal-title" id="myModalLabel1">出库/入库</h4>
            </div>

            <div class="modal-body">
                <form id="createActivityForm" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="create-productName" class="col-sm-2 control-label">产品名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-productName">
                        </div>
                        <label for="create-operateName" class="col-sm-2 control-label">操作类型<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-operateName">
                        </div>
                    </div>
                    <div class="form-group" id="colorAndCapacity">
                        <label for="create-operateNum" class="col-sm-2 control-label">数量</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-operateNum">
                        </div>
                        <label for="create-operateUser" class="col-sm-2 control-label">操作人</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-operateUser" value=${sessionScope.sessionUser.userName}>
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
                        <label for="edit-capacity" class="col-sm-2 control-label">产品容量</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-capacity">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-height" class="col-sm-2 control-label">产品高度</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-height">
                        </div>
                        <label for="edit-diameter-body" class="col-sm-2 control-label">体直径</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-body">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-diameter-outside" class="col-sm-2 control-label">瓶口外径</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-outside">
                        </div>
                        <label for="edit-diameter-inside" class="col-sm-2 control-label">瓶口内径</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-diameter-inside">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-material" class="col-sm-2 control-label">材料</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-material">
                        </div>
                        <label for="edit-stock" class="col-sm-2 control-label">产品库存</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-stock">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-weight" class="col-sm-2 control-label">产品重量</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-weight">
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
                        <div class="col-sm-10" style="width: 800px;">
<%--                            <input type="text" class="form-control" id="edit-remarks">--%>
                            <textarea class="form-control" rows="3" id="edit-remarks"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>产品操作</h3>
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
                <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 详细信息</button>
                <button type="button" class="btn btn-primary" id="input—operate"><span class="glyphicon glyphicon-plus"></span> 入库</button>
                <button type="button" class="btn btn-danger" id="output—operate"><span class="glyphicon glyphicon-minus"></span> 出库</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="chckAll"/></td>
                    <td>产品图片</td>
                    <td>单品货号</td>
                    <td>产品名称</td>
                    <td>产品库存</td>
                    <td>产品容量</td>
                    <td>产品直径</td>
                    <td>产品高度</td>
                    <td>产品重量</td>
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