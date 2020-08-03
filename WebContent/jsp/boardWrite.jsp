<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String msg = "";
	String err = request.getParameter("err");
	if(err != null) {
		switch(err) {
		case "10":
			msg = "등록 할 수 없습니다.";
			break;
		case "20":
			msg = "DB 에러 발생";
			break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<style>
	#msg {
		color: red;
	}
</style>
</head>
<body>
	<div id ="msg"><%=msg %></div>
	<div>
		<form id="frm" action="/jsp/boardWriteProc.jsp" method="post" onsubmit="return chk()">
																<!-- return false 빼고 다 날아감 false도 날아가고  -->
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
	<script>
		function eleValid(ele, nm) {
			if(ele.value.length == 0){
				alert(nm+'을(를) 입력해 주세요')
				ele.focus()
				return true
			}
		}
		
		
		function chk() {
//			console.log(`title: \${frm.title.value}`)
			if(eleValid(frm.title, '제목')) {
				return false
			} else if(eleValid(frm.ctnt,'내용')) {
				return false
			} else if(eleValid(frm.i_student,'작성자')) {
				return false
			}
		}
		
/*		function chk() {
			console.log(`title : \${frm.title.value}`)
			// 이거랑 똑같음 console.log('title : ' + frm.title.value)
			
			if(frm.title.value == ''){
				alert('제목을 입력해 주세요.')
				frm.title.focus()
				return false
			} else if(frm.ctnt.value.length == 0){
				alert('내용을 입력해 주세요.')
				frm.ctnt.focus()
				return false
			}
		}
*/
	</script>
</body>
</html>