<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%!
	private Connection getCon() throws Exception {
	
		String url = "jdbc:oracle:thin:@localhost:1521:orcl2";
		String username = "hr";
		String password = "koreait2020";
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		Connection con = DriverManager.getConnection(url, username, password);
		System.out.println("접속성공");
		return con;
	}
%>
<%
	String strI_board = request.getParameter("i_board");
	int i_board = Integer.parseInt(strI_board);	

	String title = request.getParameter("title");
	String ctnt = request.getParameter("ctnt");
	String strI_student = request.getParameter("i_student");
	
	if("".equals(title) || "".equals(ctnt) || "".equals(strI_student)) {
		response.sendRedirect("/jsp/boardMod.jsp?err=10");
		return;
	}

	int i_student = Integer.parseInt(strI_student);
	
	
	Connection con = null;
	PreparedStatement ps = null;

	String sql = " UPDATE t_board SET title=?, ctnt=?, i_student=? WHERE i_board=? ";
	
	int result = -1;
	
	try{
		con = getCon();		
		
		ps = con.prepareStatement(sql);
		ps.setString(1, title);
		ps.setString(2, ctnt);
		ps.setInt(3, i_student);
		ps.setInt(4, i_board);


		result = ps.executeUpdate();

		
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
		if(ps != null) { try{ ps.close(); } catch(Exception e) {} }
		if(con != null) { try{ con.close(); } catch(Exception e) {} }
		
	}
	
	int err = 0;
	switch(result) {
		case 1 :
			response.sendRedirect("/jsp/boardDetail.jsp?i_board=" + i_board);
			return;
		case 0 :
			err = 10;
			break;
		case -1 :
			err = 20;
			break;
	}
	response.sendRedirect("/jsp/boardDetail.jsp?err=" + err + "&i_board=" + i_board);

%>