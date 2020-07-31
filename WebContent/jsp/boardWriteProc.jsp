<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

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
	// post 방식으로 할때 한글이 깨지지 않게 하기 위해
	// get 방식은 이미 해놨음. 지난번에 메모장에서 URIEncoding 어쩌고 저쩌고
	String title = request.getParameter("title");
	String ctnt = request.getParameter("ctnt");
	String strI_student = request.getParameter("i_student");
	int i_board = 2;
	
	int i_student = Integer.parseInt(strI_student);
	
	
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	String sql = " INSERT INTO t_board(i_board, title, ctnt, i_student) "
			+ " SELECT nvl(max(i_board), 0) + 1, ?, ?, ? "
			+ " FROM t_board ";
	
	int result = -1;
	
	try{
		con = getCon();		
		ps = con.prepareStatement(sql);
		ps.setString(1, title);
		ps.setString(2, ctnt);
		ps.setInt(3, i_student);

		
		result = ps.executeUpdate();
		
		String latest = " SELECT nvl(max(i_board), 0) as latest FROM t_board ";
		ps = con.prepareStatement(latest);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			i_board = rs.getInt("latest");
		}
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
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
			response.sendRedirect("/jsp/boardDetail.jsp?i_board=" + i_board);
			break;
	}

%>

<div>title: <%=title %></div>
<div>ctnt: <%=ctnt %></div>
<div>strI_student: <%=strI_student%></div>