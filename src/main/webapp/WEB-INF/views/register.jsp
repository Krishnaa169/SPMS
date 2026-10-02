<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Student Project Management System (SPMS)</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a0ca3;
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #311042 100%);
        }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 30px 0;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 1.25rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.2);
            overflow: hidden;
            width: 100%;
            max-width: 480px;
            backdrop-filter: blur(16px);
        }
        .brand-header {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: #fff;
            padding: 2.25rem 2rem 2rem;
            text-align: center;
        }
        .brand-header h1 {
            font-family: 'Outfit', sans-serif;
            font-size: 1.75rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 0.35rem;
        }
        .brand-header .subtitle {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.85);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
        }
        .register-body {
            padding: 2.25rem;
        }
        .form-control, .form-select {
            border-radius: 0.65rem;
            border: 1.5px solid #e2e8f0;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.18);
        }
        .btn-submit {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: #fff;
            font-weight: 600;
            padding: 0.85rem;
            border-radius: 0.75rem;
            border: none;
            transition: all 0.3s;
            font-size: 1rem;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #3a0ca3 0%, #240046 100%);
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 10px 20px -5px rgba(67, 97, 238, 0.4);
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="register-card">
        <div class="brand-header">
            <div class="mb-2">
                <i class="bi bi-person-plus-fill fs-1"></i>
            </div>
            <h1>Create Account</h1>
            <div class="subtitle">Join SPMS Portal</div>
        </div>

        <div class="register-body">
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2"></i>
                    <div>${errorMsg}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold text-secondary small" for="name">
                        <i class="bi bi-person me-1"></i> Full Name <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="name" name="name"
                           placeholder="e.g. Krishna Sharma" value="${user.name}" required autofocus>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold text-secondary small" for="email">
                        <i class="bi bi-envelope me-1"></i> Email Address <span class="text-danger">*</span>
                    </label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="name@example.com" value="${user.email}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold text-secondary small" for="password">
                        <i class="bi bi-lock me-1"></i> Password <span class="text-danger">*</span>
                    </label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Create password" required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold text-secondary small" for="role">
                        <i class="bi bi-shield-check me-1"></i> Account Type
                    </label>
                    <select class="form-select" id="role" name="role">
                        <option value="ROLE_STUDENT" selected>Student</option>
                        <option value="ROLE_TEACHER">Teacher / Evaluator</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-submit w-100 mb-3">
                    <i class="bi bi-check2-circle me-1"></i> Complete Registration
                </button>

                <div class="text-center pt-2 border-top">
                    <span class="text-muted small">Already registered? </span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary text-decoration-none small">
                        Sign In here
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
