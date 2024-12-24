<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 스크립트 문장 실행시 필요한 라이브러리 -->
<%@ page import="java.io.PrintWriter" %>

<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <%
        String userID = null;
        if(session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID"); //로그인한 사람들은 해당아이디가 userID에 저장
        }

        if (userID == null) {//로그인이 안됐을 경우
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요.')");
            script.println("location.href = 'login.jsp'"); // 다시 게시글 페이지로 이동
            script.println("</script>");
        }
        int bbsID = 0; // 게시글 번호
        if (request.getParameter("bbsID") != null) {
            bbsID = Integer.parseInt(request.getParameter("bbsID"));//게시글 번호 받아오기
        }
        if (bbsID == 0) {//게시글이 존재하지 않는 다는 얘기
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 글입니다.')");
            script.println("location.href = 'bbs.jsp'"); // 다시 게시글 페이지로 이동
            script.println("</script>");
        }
        //현재 작성한 글이 작성한 본인이 한건지 확인
        Bbs bbs = new BbsDAO().getBbs(bbsID);
        if (!userID.equals(bbs.getUserID())) { // !userID세션값과 bbs.getUserID 작성한사람 동일한지
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('권한이 업습니다.')");
            script.println("location.href = 'bbs.jsp'"); // 다시 게시글 페이지로 이동
            script.println("</script>");
        }
    %>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li> <!-- 현재 페이지가 메인임을 알려줌 -->
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>

 

<!-- 로그인이 안된 상태일 경우에 대한 조치는 위에서 걸름 -->
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>


    <div class = "container">
        <div class="row">
            <form method="post" action="updateAction.jsp?bbsID=<%= bbsID %>">

            <!-- 데이터를 액션페이지로, 셀제로 글수정 -->
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식                                  </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <td>

                                <!-- 이전 작성글 제목 -->
                                <input type="text" class="form-control" placeholder="글 제                                                                                목" name="bbsTitle" maxlength="50" value="<%=bbs.getBbsTitle() %>">
                            </td>
                        </tr>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <td><textarea class="form-control" placeholder="글 내                                                                                        용" name="bbsContent" maxlength="2048" style="height: 350px;"><%=bbs.getBbsContent() %></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 데이터를 액션페이지로 -->

                <input type="submit" class="btn btn-primary pull-right" value="글수정">
            </form>
        </div>
    </div>
<script src="https://code.jquery.com/jquery-3.1.1.min.js">
<script src="js/bootstrap.js"></script>
</body>
</html>