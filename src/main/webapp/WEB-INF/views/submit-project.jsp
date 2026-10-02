<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Project - SPMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a0ca3;
            --bg-light: #f8fafc;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #1e293b;
            min-height: 100vh;
        }
        .navbar-custom {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        .navbar-brand {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.35rem;
            color: #fff !important;
        }
        .form-card {
            background: #fff;
            border-radius: 1rem;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            padding: 2rem;
        }
        .field-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.5rem;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.2);
        }
        .deadline-card {
            background: #f1f5f9;
            border-radius: 0.85rem;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/student/dashboard">
            <i class="bi bi-mortarboard-fill me-2 fs-4"></i>
            <span>SPMS <small class="fw-normal fs-6 text-white-50">| Student Portal</small></span>
        </a>
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-light btn-sm rounded-pill px-3 me-2">
                <i class="bi bi-arrow-left me-1"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm text-primary rounded-pill px-3">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Heading -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1 font-outfit">Submit Project Proposal</h2>
                    <p class="text-muted mb-0">Fill in project details below. Subject deadline rules apply automatically.</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary btn-sm rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i> Back
                </a>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-octagon-fill me-2 fs-5"></i>
                    <div>${errorMessage}</div>
                </div>
            </c:if>

            <div class="card form-card">
                <form:form modelAttribute="project" action="${pageContext.request.contextPath}/student/submit" method="post" enctype="multipart/form-data">
                    
                    <!-- Subject Selector -->
                    <div class="mb-4">
                        <label class="field-label" for="subject">
                            <i class="bi bi-book-half text-primary me-1"></i> Subject Course <span class="text-danger">*</span>
                        </label>
                        <form:select path="subject" id="subject" class="form-select form-select-lg">
                            <form:option value="" label="-- Choose Subject Course --" />
                            <form:options items="${subjects}" />
                        </form:select>
                        <form:errors path="subject" cssClass="text-danger small mt-1 fw-medium d-block" />
                        <div class="form-text">Choose the respective curriculum subject for which this project is submitted.</div>
                    </div>

                    <!-- Project Title -->
                    <div class="mb-4">
                        <label class="field-label" for="title">
                            <i class="bi bi-card-heading text-primary me-1"></i> Project Title <span class="text-danger">*</span>
                        </label>
                        <form:input path="title" id="title" class="form-control form-control-lg"
                                    placeholder="e.g., Enterprise Hospital Management System using Spring & Hibernate" />
                        <form:errors path="title" cssClass="text-danger small mt-1 fw-medium d-block" />
                        <div class="form-text">Title must be concise and descriptive (minimum 5 characters).</div>
                    </div>

                    <!-- Project Description -->
                    <div class="mb-4">
                        <label class="field-label" for="description">
                            <i class="bi bi-text-paragraph text-primary me-1"></i> Project Abstract / Description <span class="text-danger">*</span>
                        </label>
                        <form:textarea path="description" id="description" rows="6" class="form-control"
                                       placeholder="Provide a comprehensive summary of the project architecture, enterprise technologies used, modules implemented, and database design..." />
                        <form:errors path="description" cssClass="text-danger small mt-1 fw-medium d-block" />
                        <div class="form-text">Minimum 10 characters detailing objectives and tech stack.</div>
                    </div>

                    <!-- Project PDF Documentation Upload -->
                    <div class="mb-4">
                        <label class="field-label" for="pdfFile">
                            <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i> Project Documentation (PDF)
                        </label>
                        <input type="file" class="form-control form-control-lg" id="pdfFile" name="pdfFile" accept="application/pdf,.pdf" />
                        <div class="form-text">Attach project documentation, synopsis, or report in PDF format (Max 20MB).</div>
                    </div>

                    <!-- Deadlines Advisory Box -->
                    <c:if test="${not empty deadlines}">
                        <div class="deadline-card p-3 mb-4">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-info-circle-fill text-primary me-2"></i>
                                <span class="fw-bold small text-uppercase text-secondary">Active Subject Deadlines Reminder</span>
                            </div>
                            <div class="row row-cols-1 row-cols-md-2 g-2">
                                <c:forEach var="dl" items="${deadlines}">
                                    <div class="col">
                                        <div class="p-2 bg-white rounded border small">
                                            <div class="fw-semibold text-truncate">${dl.subject}</div>
                                            <div class="text-muted">
                                                Due: <fmt:formatDate value="${dl.dueDate}" pattern="dd MMM yyyy, hh:mm a" />
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-2 pt-2 border-top">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-light px-4 rounded-pill">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold rounded-pill shadow-sm">
                            <i class="bi bi-send-fill me-1"></i> Submit Project
                        </button>
                    </div>

                </form:form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
