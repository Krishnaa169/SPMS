<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - SPMS</title>
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
            font-size: 0.82rem;
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
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/teacher/dashboard">
            <i class="bi bi-mortarboard-fill me-2 fs-4 text-warning"></i>
            <span>SPMS <small class="fw-normal fs-6 text-white-50">| Teacher &amp; Evaluator Portal</small></span>
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/teacher/deadlines" class="btn btn-warning btn-sm rounded-pill px-3 fw-semibold text-dark">
                <i class="bi bi-calendar-event me-1"></i> Manage Deadlines
            </a>
            <span class="badge bg-white bg-opacity-25 text-white px-3 py-2 rounded-pill">
                <i class="bi bi-person-badge me-1"></i> ${teacher.name}
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
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-octagon-fill me-2 fs-5"></i>
            <div>${errorMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Header info -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1 font-outfit">Project Evaluation &amp; Review Center</h2>
            <p class="text-muted mb-0">Evaluate student project submissions, assign approval status, and enforce deadlines.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/teacher/deadlines" class="btn btn-outline-primary rounded-pill">
                <i class="bi bi-alarm-fill me-1"></i> Cutoff Deadlines
            </a>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary p-3 me-3">
                        <i class="bi bi-stack fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">All Projects</div>
                        <h4 class="fw-bold mb-0">${totalCount}</h4>
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
                        <div class="text-muted small fw-medium">Needs Review</div>
                        <h4 class="fw-bold mb-0">${pendingCount}</h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-6 col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex align-items-center">
                    <div class="rounded-3 bg-success bg-opacity-10 text-success p-3 me-3">
                        <i class="bi bi-check-circle-fill fs-4"></i>
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
                        <i class="bi bi-x-octagon-fill fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small fw-medium">Rejected</div>
                        <h4 class="fw-bold mb-0">${rejectedCount}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Buttons and Projects Table -->
    <div class="card table-card mb-4">
        <div class="card-header bg-white py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-0 gap-2">
            <h5 class="fw-bold mb-0">
                <i class="bi bi-list-check text-primary me-2"></i>All Student Submissions
            </h5>
            <div class="btn-group btn-group-sm" role="group">
                <button type="button" class="btn btn-outline-secondary active" onclick="filterProjects('ALL', this)">All</button>
                <button type="button" class="btn btn-outline-warning text-dark" onclick="filterProjects('PENDING', this)">Pending</button>
                <button type="button" class="btn btn-outline-success" onclick="filterProjects('APPROVED', this)">Approved</button>
                <button type="button" class="btn btn-outline-danger" onclick="filterProjects('REJECTED', this)">Rejected</button>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table mb-0 align-middle" id="projectsTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student Name &amp; Email</th>
                        <th>Subject</th>
                        <th>Project Title</th>
                        <th>Submitted On</th>
                        <th>Current Status</th>
                        <th class="text-center" style="min-width: 230px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty projects}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-journal-x fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                    <p class="mb-0 fw-semibold">No student project submissions recorded yet.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="proj" items="${projects}">
                                <tr data-status="${proj.status}">
                                    <td class="fw-bold text-muted">${proj.id}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${proj.student.name}</div>
                                        <small class="text-muted"><i class="bi bi-envelope me-1"></i>${proj.student.email}</small>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border">
                                            <i class="bi bi-book me-1 text-primary"></i>${proj.subject}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="fw-semibold text-dark">${proj.title}</div>
                                        <a href="javascript:void(0)" class="text-decoration-none small text-primary"
                                           data-bs-toggle="modal" data-bs-target="#teacherModal_${proj.id}">
                                            <i class="bi bi-text-left me-1"></i>View Details
                                        </a>
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
                                    <td class="text-center">
                                        <div class="d-inline-flex gap-1 align-items-center">
                                            <!-- Download PDF Button if present -->
                                            <c:if test="${not empty proj.documentPath}">
                                                <a href="${pageContext.request.contextPath}/teacher/download/${proj.id}" target="_blank"
                                                   class="btn btn-outline-danger btn-sm rounded-pill px-2" title="View Attached PDF (${proj.documentName})">
                                                    <i class="bi bi-file-earmark-pdf-fill"></i>
                                                </a>
                                            </c:if>

                                            <!-- Approve Button Form -->
                                            <form action="${pageContext.request.contextPath}/teacher/update-status" method="post" class="d-inline">
                                                <input type="hidden" name="projectId" value="${proj.id}" />
                                                <input type="hidden" name="status" value="APPROVED" />
                                                <button type="submit" class="btn btn-success btn-sm rounded-pill px-2"
                                                        title="Approve Project"
                                                        <c:if test="${proj.status == 'APPROVED'}">disabled</c:if>>
                                                    <i class="bi bi-check-lg"></i> Approve
                                                </button>
                                            </form>

                                            <!-- Reject Button Form -->
                                            <form action="${pageContext.request.contextPath}/teacher/update-status" method="post" class="d-inline">
                                                <input type="hidden" name="projectId" value="${proj.id}" />
                                                <input type="hidden" name="status" value="REJECTED" />
                                                <button type="submit" class="btn btn-danger btn-sm rounded-pill px-2"
                                                        title="Reject Project"
                                                        <c:if test="${proj.status == 'REJECTED'}">disabled</c:if>>
                                                    <i class="bi bi-x-lg"></i> Reject
                                                </button>
                                            </form>

                                            <!-- Reset to Pending if needed -->
                                            <c:if test="${proj.status != 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/teacher/update-status" method="post" class="d-inline">
                                                    <input type="hidden" name="projectId" value="${proj.id}" />
                                                    <input type="hidden" name="status" value="PENDING" />
                                                    <button type="submit" class="btn btn-outline-secondary btn-sm rounded-pill px-2"
                                                            title="Reset to Pending">
                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Description Modal -->
                                <div class="modal fade" id="teacherModal_${proj.id}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title fw-bold">Project #${proj.id} - ${proj.title}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <span class="badge bg-light text-dark border me-1">Student: ${proj.student.name}</span>
                                                    <span class="badge bg-light text-dark border">Subject: ${proj.subject}</span>
                                                </div>
                                                <div class="p-3 bg-light rounded border mb-3">
                                                    <h6 class="fw-bold mb-2">Project Description:</h6>
                                                    <p class="mb-0" style="white-space: pre-wrap;">${proj.description}</p>
                                                </div>
                                                <c:if test="${not empty proj.documentPath}">
                                                    <div class="p-3 bg-light rounded border">
                                                        <h6 class="fw-bold mb-1">Attached PDF Documentation:</h6>
                                                        <p class="small text-muted mb-2">${proj.documentName}</p>
                                                        <a href="${pageContext.request.contextPath}/teacher/download/${proj.id}" target="_blank"
                                                           class="btn btn-danger btn-sm rounded-pill px-3">
                                                            <i class="bi bi-file-earmark-pdf-fill me-1"></i> Open / Download PDF
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterProjects(status, btn) {
        document.querySelectorAll('.btn-group .btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const rows = document.querySelectorAll('#projectsTable tbody tr[data-status]');
        rows.forEach(row => {
            if (status === 'ALL' || row.getAttribute('data-status') === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
