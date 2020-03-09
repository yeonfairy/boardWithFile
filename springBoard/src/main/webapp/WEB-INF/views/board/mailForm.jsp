<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 메일 발송 폼</title>
<style>
#container {
	width: 800px;
	margin: auto;
}
h2 {
	text-align: center;
}
table {
	width: 100%;
}
table td {
	border: 1px solid #ccc;
}
table input, table textarea {
	width: 99%;
}
textarea {
	min-height: 300px;
}

tr:nth-child(5) td {
	text-align: left;
}
tr:nth-child(6) td {
	text-align: center;
}
</style>
<!-- 스마트 에디터 -->
<script type="text/javascript" src="<%=request.getContextPath()  %> /smarteditor/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<!-- include libraries(jQuery, bootstrap) -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- include summernote css/js -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.16/dist/summernote.min.js"></script>
</head>
<body>
<div id="container">
        <form action="sendMail.do" method="post">
            <table>
                <tr><th colspan="2"><h2>문의사항 메일쓰기</h2></th></tr>
                <tr><td>보내는사람</td><td><input type="text" name="from" /></td></tr>
                <tr><td>받는사람</td><td><input type="text" name="to" /></td></tr>
                <tr><td>제목</td><td><input type="text" name="subject" /></td></tr>
                <tr><td>내용</td>
                  <td><textarea id ="summernote" name="content"></textarea></td></tr>
                <tr><td colspan="2" style="text-align:right;"><input type="submit" value="보내기"/></td></tr>
            </table>
            	<button type="button" onclick="location.href='board.do'">목록</button>
        </form>
    </div>
</body>
<script>
$(document).ready(function() {
	$('#summernote').summernote({
		  height: 300,                 // 에디터 높이
		  minHeight: null,             // 최소 높이
		  maxHeight: null,             // 최대 높이
		  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
		  lang: "ko-KR",					// 한글 설정
		  placeholder: ''	//placeholder 설정
          
	});
});
</script>
</html>
