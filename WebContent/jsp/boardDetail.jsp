<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.koreait.web.BoardVO"%>      
<%!
	private Connection getCon() throws Exception {
	
		String url = "jdbc:oracle:thin:@localhost:1521:orcl2";
		String username = "hr";
		String password = "koreait2020";
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		//getConnection은 DriverManager클래스(대문자시작이니까)의 static메소드->생성안해줘도 사용가능
		Connection con = DriverManager.getConnection(url, username, password);
		System.out.println("접속성공");
		return con;
	}
%>    
<%
						// 겟/포스트방식 둘다 getParameter로 
	String strI_board = request.getParameter("i_board");
	//String strCtnt = request.getParameter("ctnt");
	if(strI_board == null) {
%>
	<script>
		alert('잘못된 접근입니다.')
		location.href='/jsp/boardlist.jsp'
	</script>
<%
	return;
	//리턴이 꼭 들어가야됨. 없으면 밑에거도 다 실행
	}
	
	int i_board = Integer.parseInt(strI_board);

	BoardVO vo = new BoardVO();
	 
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	String sql = " SELECT title, ctnt, i_student FROM t_board WHERE i_board = ?";
		
	try{
		con = getCon();		
		ps = con.prepareStatement(sql);
		ps.setInt(1, i_board);
		//ps.setString(1, strI_board); 문자열일경우 홑따옴표를 자동으로 넣어줌.
		//            1번째 물음표에 strI_board값을 주입하겠다.
		
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String title = rs.getNString("title");
			String ctnt = rs.getNString("ctnt");
			int i_student = rs.getInt("i_student");
			
			vo.setTitle(title);
			vo.setCtnt(ctnt);
			vo.setI_student(i_student);
		}
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
		// 만약에 안닫아주면? 서버가 죽는당
		// 닫을때는 반대로 닫아야한다. rs -> ps -> con
		// 3개를 다 같이 한번에 안닫는 이유? 다 묶어주면 하나가 에러터지면 그 뒤에 있는건 실행안되서 안닫힘.
		if(rs != null) { try{ rs.close(); } catch(Exception e) {} }
		if(ps != null) { try{ ps.close(); } catch(Exception e) {} }
		if(con != null) { try{ con.close(); } catch(Exception e) {} }
		
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상세 페이지</title>
<style>
	* { background: skyblue; }
	.container { width: 100%; height: 100px; margin: 0 auto;
					 }
	h2 { display: block; text-align: center; font-size: 100px;}
	table { border-collapse: collapse; margin: 0 auto; }
	tr, th, td { text-align: center; font-size: 50px; }
</style>
</head>
<body>
	<div>
		<a href="/jsp/boardlist.jsp">리스트로 가기</a>
		<a href="#" onclick="procDel(<%=i_board%>)">삭제</a>
		<a href="/jsp/boardMod.jsp?i_board=<%=i_board%>">수정</a>
	</div>
	<div>제목 : <%=vo.getTitle() %></div>
	<div>내용 : <%=vo.getCtnt() %></div>
	<div>작성자 : <%=vo.getI_student() %></div>
	<script>
		function procDel(i_board) {
			//alert('i_board : ' + i_board)
			if(confirm('삭제 하시겠습니까?')) {
				location.href = '/jsp/boardDel.jsp?i_board=' + i_board
			}
		}
	</script>
</body>
</html>