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
	
	int i_board = Integer.parseInt(strI_board);

	BoardVO vo = new BoardVO();
	 
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	String sql = " DELETE FROM t_board WHERE i_board = ?";
	
	int result = -1;
	
	try{
		con = getCon();		
		ps = con.prepareStatement(sql);
		ps.setInt(1, i_board);
		
		result = ps.executeUpdate();
		
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
		// 만약에 안닫아주면? 서버가 죽는당
		// 닫을때는 반대로 닫아야한다. rs -> ps -> con
		// 3개를 다 같이 한번에 안닫는 이유? 다 묶어주면 하나가 에러터지면 그 뒤에 있는건 실행안되서 안닫힘.
		//if(rs != null) { try{ rs.close(); } catch(Exception e) {} }
		if(ps != null) { try{ ps.close(); } catch(Exception e) {} }
		if(con != null) { try{ con.close(); } catch(Exception e) {} }
		
	}
	
	System.out.println("result: " + result);
	switch(result) {
		case -1 :
			response.sendRedirect("/jsp/boardDetail.jsp?err=-1&i_board=" + i_board);
			break;
		case 0 :
			response.sendRedirect("/jsp/boardDetail.jsp?err=0&i_board=" + i_board);
			break;
		case 1 :
			response.sendRedirect("/jsp/boardlist.jsp");
			break;
	}

%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<p>게시글이 삭제되었습니다.</p>
</body>
</html>