<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - SPMS</title>
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
        .welcome-card {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            color: white;
            border-radius: 1rem;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 25px -5px rgba(30, 27, 75, 0.25);
        }
        .stat-card {
            border: none;
            border-radius: 0.85rem;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            background: #fff;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .badge-pending {
            background-color: #fef3c7;
            color: #92400e;
            border: 1px solid #fde68a;
        }
        .badge-approved {
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        .badge-rejected {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        .table-card {
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
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/student/dashboard">
            <i class="bi bi-mortarboard-fill me-2 fs-4"></i>
            <span>SPMS <small class="fw-normal fs-6 text-white-50">| Student Portal</small></span>
        </a>
        <div class="d-flex align-items-center">
            <span class="badge bg-white bg-opacity-25 text-white px-3 py-2 rounded-pill me-3">
                <i class="bi bi-person-circle me-1"></i> ${student.name}
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm rounded-pill px-3">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container my-4">

    <!-- Flash Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle-fill me-2 fs-5"></i>
            <div>${successMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Welcome Hero Banner -->
    <div class="welcome-card d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div>
            <h2 class="fw-bold mb-1 font-outfit">Hello, ${student.name}! 👋</h2>
            <p class="mb-0 text-white-50">
                Course Projects &amp; Evaluation Tracker
            </p>
            <small class="text-white-50"><i class="bi bi-envelope me-1"></i> ${student.email}</small>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/student/submit" class="btn btn-warning btn-lg fw-bold shadow-sm px-4 text-dark rounded-pill">
                <i class="bi bi-cloud-arrow-up-fill me-1"></i> Submit New Project
            </a>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="row g-3 mb-4">
        <c:set var="totalSubmissions" value="${projects.size()}" />
        <c:set var="pendingCount" value="0" />
        <c:set var="approvedCount" value="0" />
        <c:set var="rejectedCount" value="0" />
        <c:forEach var="p" items="${projects}">
            <c:if test="${p.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
            <c:if test="${p.status == 'APPROVED'}"><c:set var="approvedCount" value="${approvedCount + 1}" /></c:if>
            <c:if test="${p.status == 'REJECTED'}"><c:set var="rejectedCount" value="${rejectedCount + 1}" /></c:if>
        </c:forEach>

        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-3 me-3">
                        <i class="bi bi-folder-fill fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">Submitted</div>
                        <h4 class="fw-bold mb-0">${totalSubmissions}</h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-warning bg-opacity-10 text-warning p-3 me-3">
                        <i class="bi bi-hourglass-split fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">Under Review</div>
                        <h4 class="fw-bold mb-0">${pendingCount}</h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-success bg-opacity-10 text-success p-3 me-3">
                        <i class="bi bi-patch-check-fill fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">Approved</div>
                        <h4 class="fw-bold mb-0">${approvedCount}</h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-danger bg-opacity-10 text-danger p-3 me-3">
                        <i class="bi bi-x-circle-fill fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">Rejected</div>
                        <h4 class="fw-bold mb-0">${rejectedCount}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Row -->
    <div class="row g-4">
        <!-- Projects Table -->
        <div class="col-lg-8">
            <div class="card table-card">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-0">
                    <h5 class="fw-bold mb-0">
                        <i class="bi bi-journal-code text-primary me-2"></i>My Project Submissions
                    </h5>
                    <a href="${pageContext.request.contextPath}/student/submit" class="btn btn-primary btn-sm rounded-pill px-3">
                        <i class="bi bi-plus-lg me-1"></i> Submit New
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table mb-0 align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Project Title</th>
                                <th>Subject</th>
                                <th>Submitted On</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty projects}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                            <p class="mb-2 fw-semibold">No project submissions yet.</p>
                                            <small class="text-muted d-block mb-3">Submit your semester project before the subject deadline.</small>
                                            <a href="${pageContext.request.contextPath}/student/submit" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                Submit Your First Project
                                            </a>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="proj" items="${projects}">
                                        <tr>
                                            <td class="fw-bold text-muted">${proj.id}</td>
                                            <td>
                                                <div class="fw-semibold text-dark">${proj.title}</div>
                                                <small class="text-muted text-truncate d-inline-block" style="max-width: 250px;">
                                                    ${proj.description}
                                                </small>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border">
                                                    <i class="bi bi-book me-1 text-primary"></i> ${proj.subject}
                                                </span>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${proj.submissionDate}" pattern="dd MMM yyyy, hh:mm a" />
                                                </small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${proj.status == 'APPROVED'}">
                                                        <span class="badge badge-approved px-2 py-1 rounded-pill">
                                                            <i class="bi bi-check2-circle me-1"></i> Approved
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${proj.status == 'REJECTED'}">
                                                        <span class="badge badge-rejected px-2 py-1 rounded-pill">
                                                            <i class="bi bi-x-circle me-1"></i> Rejected
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-pending px-2 py-1 rounded-pill">
                                                            <i class="bi bi-clock-history me-1"></i> Pending
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-inline-flex gap-1 align-items-center">
                                                    <c:if test="${not empty proj.documentPath}">
                                                        <a href="${pageContext.request.contextPath}/student/download/${proj.id}" target="_blank"
                                                           class="btn btn-outline-danger btn-sm rounded-pill px-2" title="Download Attached PDF Documentation">
                                                            <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                        </a>
                                                    </c:if>
                                                    <button class="btn btn-outline-secondary btn-sm rounded-pill"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#descModal_${proj.id}">
                                                        <i class="bi bi-eye"></i> View
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Project Modal -->
                                        <div class="modal fade" id="descModal_${proj.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Project #${proj.id} Details</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <h5 class="text-primary fw-semibold">${proj.title}</h5>
                                                        <p class="text-muted small mb-2"><strong>Subject:</strong> ${proj.subject}</p>
                                                        <p class="text-muted small mb-3"><strong>Submitted:</strong> <fmt:formatDate value="${proj.submissionDate}" pattern="dd MMM yyyy, hh:mm a" /></p>
                                                        <div class="p-3 bg-light rounded border">
                                                            <h6 class="fw-bold mb-2">Description / Abstract:</h6>
                                                            <p class="mb-0" style="white-space: pre-wrap;">${proj.description}</p>
                                                        </div>
                                                        <c:if test="${not empty proj.documentPath}">
                                                            <div class="mt-3 pt-3 border-top">
                                                                <span class="small fw-semibold text-secondary d-block mb-1">Attached Documentation:</span>
                                                                <a href="${pageContext.request.contextPath}/student/download/${proj.id}" target="_blank" class="btn btn-outline-danger btn-sm rounded-pill">
                                                                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> View / Download PDF (${proj.documentName})
                                                                </a>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Deadlines Sidebar -->
        <div class="col-lg-4">
            <div class="card table-card">
                <div class="card-header bg-white py-3 border-0">
                    <h5 class="fw-bold mb-0">
                        <i class="bi bi-calendar-event text-danger me-2"></i>Subject Deadlines
                    </h5>
                    <small class="text-muted">Ensure submissions are on or before the due date</small>
                </div>
                <div class="card-body p-0">
                    <jsp:useBean id="now" class="java.util.Date" />
                    <ul class="list-group list-group-flush">
                        <c:choose>
                            <c:when test="${empty deadlines}">
                                <li class="list-group-item text-center py-4 text-muted small">
                                    <i class="bi bi-calendar-check fs-2 d-block mb-1 text-success"></i>
                                    No strict deadlines configured yet.<br>All subjects are currently open!
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="dl" items="${deadlines}">
                                    <li class="list-group-item p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <span class="fw-semibold text-dark">${dl.subject}</span>
                                            <c:choose>
                                                <c:when test="${now.time <= dl.dueDate.time}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                        <i class="bi bi-unlock-fill me-1"></i> Open
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                                                        <i class="bi bi-lock-fill me-1"></i> Closed
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-clock me-1"></i> Cutoff: 
                                            <strong><fmt:formatDate value="${dl.dueDate}" pattern="dd MMM yyyy, hh:mm a" /></strong>
                                        </div>
                                    </li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
