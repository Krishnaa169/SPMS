<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set Deadlines - SPMS</title>
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
            background: linear-gradient(135deg, #1e1b4b 0%, #311042 100%);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }
        .navbar-brand {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.35rem;
            color: #fff !important;
        }
        .custom-card {
            background: #fff;
            border-radius: 1rem;
            border: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }
        .table thead th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/teacher/dashboard">
            <i class="bi bi-mortarboard-fill me-2 fs-4 text-warning"></i>
            <span>SPMS <small class="fw-normal fs-6 text-white-50">| Teacher Portal</small></span>
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-outline-light btn-sm rounded-pill px-3">
                <i class="bi bi-arrow-left me-1"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-light btn-sm text-primary rounded-pill px-3">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container my-5">

    <!-- Flash Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i>
            <div>${successMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-exclamation-octagon-fill me-2 fs-5"></i>
            <div>${errorMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Set Deadline Form -->
        <div class="col-lg-5">
            <div class="card custom-card p-4">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3 me-2">
                        <i class="bi bi-clock-history fs-4"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0 font-outfit">Set / Update Deadline</h5>
                        <small class="text-muted">Submissions after this cutoff will be locked</small>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/teacher/deadlines" method="post" id="deadlineForm">
                    <div class="mb-3">
                        <label for="subjectSelect" class="form-label fw-semibold">
                            <i class="bi bi-book me-1 text-primary"></i> Subject Course
                        </label>
                        <select class="form-select form-select-lg" id="subjectSelect" name="subject" required>
                            <option value="">-- Choose Subject --</option>
                            <c:forEach var="sub" items="${subjects}">
                                <option value="${sub}">${sub}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Choose the subject to assign or update the deadline for.</div>
                    </div>

                    <div class="mb-4">
                        <label for="dueDateInput" class="form-label fw-semibold">
                            <i class="bi bi-calendar2-week me-1 text-primary"></i> Cutoff Date &amp; Time
                        </label>
                        <input type="datetime-local" class="form-control form-control-lg"
                               id="dueDateInput" name="dueDate" required>
                        <div class="form-text">Students cannot submit projects after this exact timestamp.</div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold rounded-pill shadow-sm">
                        <i class="bi bi-save-fill me-1"></i> Save Subject Deadline
                    </button>
                </form>
            </div>
        </div>

        <!-- Deadlines List Table -->
        <div class="col-lg-7">
            <div class="card custom-card">
                <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0">
                        <i class="bi bi-calendar-check text-success me-2"></i>Active Configured Deadlines
                    </h5>
                    <span class="badge bg-light text-secondary border">${deadlines.size()} Configured</span>
                </div>

                <div class="table-responsive">
                    <table class="table mb-0 align-middle">
                        <thead>
                            <tr>
                                <th>Subject Course</th>
                                <th>Cutoff Due Date</th>
                                <th>Status</th>
                                <th class="text-end">Quick Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <jsp:useBean id="now" class="java.util.Date" />
                            <c:choose>
                                <c:when test="${empty deadlines}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            <i class="bi bi-calendar-x fs-2 d-block mb-1 text-secondary opacity-50"></i>
                                            No deadlines configured yet.<br>All subject submissions are currently open.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dl" items="${deadlines}">
                                        <tr>
                                            <td>
                                                <span class="fw-bold text-dark">${dl.subject}</span>
                                            </td>
                                            <td>
                                                <div class="small fw-semibold text-dark">
                                                    <fmt:formatDate value="${dl.dueDate}" pattern="dd MMM yyyy, hh:mm a" />
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${now.time <= dl.dueDate.time}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">
                                                            <i class="bi bi-check-circle me-1"></i> Active / Open
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1 rounded-pill">
                                                            <i class="bi bi-lock-fill me-1"></i> Closed / Passed
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill"
                                                        onclick="editDeadline('${dl.subject}', '<fmt:formatDate value="${dl.dueDate}" pattern="yyyy-MM-dd\'T\'HH:mm" />')">
                                                    <i class="bi bi-pencil-square me-1"></i> Edit
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editDeadline(subject, formattedDate) {
        const select = document.getElementById('subjectSelect');
        select.value = subject;
        document.getElementById('dueDateInput').value = formattedDate;
        select.scrollIntoView({ behavior: 'smooth' });
    }
</script>
</body>
</html>
