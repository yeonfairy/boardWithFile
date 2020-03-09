<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardInsert</title>
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

tr:nth-child(3) td {
	text-align: left;
}

tr:nth-child(4) td {
	text-align: right;
}

tr:nth-child(5) td {
	text-align: center;
}
</style>
<!-- 스마트 에디터 -->
<script type="text/javascript"
	src="<%=request.getContextPath()%> /smarteditor/js/service/HuskyEZCreator.js"
	charset="utf-8"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"
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
		<h2>글쓰기</h2>
		<form action="boardInsert.do" method="post"
			enctype="multipart/form-data">
			<input type="hidden" id="BOARD_NO" name="BOARD_NO" value="">
			<input type="hidden" name="boardWriter" value="${ loginUser.userId }">
			<input type="hidden" name="boardPwd">
			<input type="hidden" name="imageFile">			
			<table>
				<tr>
					<td>제목</td>
					<td><input type="text" name="boardTitle"></td>
				</tr>
				<tr>
					<td>내용</td>
					<td><textarea id="summernote" name="boardContent">
					</br>
					</textarea></td>
				</tr>
				<tr>
					<td>첨부파일</td>
					<td><input type="file" name="file"><br /></td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="pwdInput" onclick="pwdWindowOpen();">비밀번호
							설정</button> <span id="pwdResult"> N </span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button id="saveAll">저장</button>
						<button type="button" onclick="location.href='board.do'">취소</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
<script>
	function pwdWindowOpen() {
		window.open("inputPwd.do", null, "width=800 height=400");
	}
	function pwdSetting(str) {
		$("input[name=boardPwd]").val(str);
		$("#pwdResult").text(" Y ");
		alert("비밀번호가 설정 되었습니다.");
	}
	$(document).ready(function() {
		$('#summernote').summernote({
			height : 300, // 에디터 높이
			minHeight : null, // 최소 높이
			maxHeight : null, // 최대 높이
			focus : true, // 에디터 로딩후 포커스를 맞출지 여부
			lang : "ko-KR", // 한글 설정
			placeholder : '', //placeholder 설정
				callbacks: {	//여기 부분이 이미지를 첨부하는 부분
					onImageUpload : function(files) {
						 for (var i = files.length - 1; i >= 0; i--) {
						uploadSummernoteImageFile(files[i],this);
					}
			         }
				}
		});
	});
/**
* 이미지 파일 업로드
*/
function uploadSummernoteImageFile(file, editor) {
	data = new FormData();
	data.append("imageFile", file);
	$.ajax({
		data : data,
		type : "POST",
		url : "uploadSummernoteImageFile.do",
		contentType : false,
		enctype: 'multipart/form-data',
		processData : false,
		success : function(data) {
        	//항상 업로드된 파일의 url이 있어야 한다.
			$(editor).summernote('editor.insertImage', data.url); //에디터에 이미지 출력
        	alert("이미지가 성공적으로 업로드 되었습니다.");
            $('#imageBoard > ul').append('<li><img src="'+url+'" width="480" height="auto"/></li>');
		}
	});
}
</script>
</html>