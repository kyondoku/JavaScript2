<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<style>
	.jj{
		background-color: coral;
	}
	.bb{
		
	}

</style>
</head>
<body>
	<div>
		<form action="/jsp/boardWriteProc.jsp" method="post">
						<!-- 
							위 jsp는 처리하는 담당 
							보안이 필요없는 경우에는 post대신 get방식으로 해도 된다.
						-->
						<!-- 		id는 주로 자바스크립트, class는 주로 css에 대해 사용	-->
			<div><label>제목: <input type="text" name="title"></label></div>
			<div><label>내용: <textarea name="ctnt"></textarea></label></div>			
			<div><label>작성자: <input type="text" name="i_student"></label></div>		
			<div><input type="submit" value="글등록"></div>	
		</form>
	</div>
</body>
</html>