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
	function fn_fileDown(boardNo){
		var formObj = $("form[name='readForm']");
		$("#BOARD_NO").attr("value", boardNo);
		formObj.attr("action", "fileDown.do");
		formObj.submit();
	}
</script>
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
<h2>세부사항 조회</h2>
      <section id="container">
      
	    <form name="file" role="form" method="post" enctype="multipart/form-data"> 
			<input type="hidden" id="BOARD_NO" name="BOARD_NO" value=""> 
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
				<textarea readonly id ="summernote"> ${ board.boardContent }</textarea>
			</td>
		</tr>	
		<td>
				<div class="form-group" style="border: 1px solid #dbdbdb;">
					<c:forEach var="file" items="${file}">
					첨부파일:	 <a href="fileDown.do?boardNo=${ file.BOARD_NO }">${ file.ORG_FILE_NAME }</a>(${file.FILE_SIZE}kb)
					</c:forEach>
				</div>
		</td>
	</table></br>
	<button type="button" onclick="openSettingPwd();">비밀번호 설정</button>
	<button type="button" onclick="location.href='board.do'">목록</button>
	<button><a href="updateForm.do?boardNo=${ board.boardNo }">수정</a></button>
	<button type="button" onclick="openDeleting();">삭제</button>
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
				alert("비밀번호가 설정이 되었습니다.");
			} else {
				alert("비밀번호 설정에 실패 하였습니다.");
			}
		}
	});
}
function openDeleting(){
	$.ajax({
		url: "deleteBoard.do",
		data: { boardNo: ${ board.boardNo } },
		type: "POST",
		error: function(e) {console.log(e);},
		success: function(result) {
			alert("삭제 되었습니다.");
			location.href='board.do';
		}
	});
}
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