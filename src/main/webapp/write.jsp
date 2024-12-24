<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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

            <% // 로그인이 되어있지 않은 사람들만 로그인 회원가입 보이게
                if(userID == null) {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>
            <%//로그인이 되어있다면
                } else {
            %>
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
            <%
                }
            %>
        </div>
    </nav>


    <div class = "container">
        <div class="row">
            <form method="post" action="writeAction.jsp"><!-- 데이터를 액션페이지로, 셀제로 글등록 -->
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식                                  </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <td>
                                <input type="text" class="form-control" placeholder="글 제                                                                                목" name="bbsTitle" maxlength="50">
                            </td>
                        </tr>
                        <tr><!-- 테이블의 행, 한줄 -->
                            <td><textarea class="form-control" placeholder="글 내                                                                                        용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 데이터를 액션페이지로 -->

                <input type="submit" class="btn btn-primary pull-right" value="글쓰기">
            </form>
        </div>
    </div>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>