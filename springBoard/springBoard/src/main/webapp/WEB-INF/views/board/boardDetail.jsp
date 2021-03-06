<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardDetail</title>
<style>
#container {
	width: 800px;
	margin: auto;
}
#container table {
	width: 100%;
}
#container td {
	border: 1px solid #ccc;
}
#container textarea {
	width: 99%;
	min-height: 300px;
	height: 100%;
}
</style>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<script type="text/javascript">
	function fn_fileDown(bNo)
	{
		var f = document.createElement('form');
		var input = document.createElement('input');
		input.setAttribute("value",bNo);
		f.action="fileDown.do";
		f.submit();
	}
</script>
</head>
<body>
<div id="container">
<h2>세부사항 조회</h2>
      <section id="container">
	    <form name="f" role="form" method="post" enctype="multipart/form-data"> 
			<input type="hidden" id="bNo" name="bNo" value=""> 
	<table>
		<tr>
			<td>번호</td>
			<td>제목</td>
			<td>작성자</td>
			<td>조회수</td>
		</tr>
		<tr>
			<td>${ board.boardNo }</td>
			<td>${ board.boardTitle }</td>
			<td>${ board.boardWriter }</td>
			<td>${ board.boardCount }</td>
		</tr>
		<tr>
			<td colspan="4">
				<textarea readonly>${ board.boardContent }</textarea>
			</td>
		</tr>	
			<td> <span> 첨부파일 다운로드 </span> <br/>	
			<td>
		    <c:forEach var="file" items="${file}">
			<a href="#" onclick="fn_fileDown('${file.BNO}'); return false;">${file.ORG_FILE_NAME}</a><br>
			</c:forEach>
			</td>
	</table></br>
	<button type="button" onclick="openSettingPwd();">비밀번호 설정</button>
	<button type="button" onclick="location.href='board.do'">목록</button>
	</section>
	</form>
</div>
</body>
<script>
function openSettingPwd(){
	window.open("inputPwd.do", null, "width=800 height=400");
}
function pwdSetting(str) {
	$.ajax({
		url: "settingpwd.do",
		data: { pwd: str,
				bNo: ${ board.boardNo } },
		type: "POST",
		error: function(e) {console.log(e);},
		success: function(result) {
			if (result > 0 ) {
				alert("비밀번호가 설정 되었습니다.");
			} else {
				alert("비밀번호 설정에 실패 하였습니다.");
			}
		}
	});
}
</script>
</html>