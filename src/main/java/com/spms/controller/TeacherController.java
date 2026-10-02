package com.spms.controller;

import com.spms.model.Deadline;
import com.spms.model.Project;
import com.spms.model.User;
import com.spms.service.DeadlineService;
import com.spms.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.beans.PropertyEditorSupport;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private DeadlineService deadlineService;

    private static final List<String> DEFAULT_SUBJECTS = Arrays.asList(
            "Enterprise Application Development",
            "Software Quality Assurance",
            "Security in Computing",
            "Business Intelligence",
            "Principles of Geographic Information Systems",
            "Internet of Things",
            "Advanced Web Development",
            "Artificial Intelligence"
    );

    private User getAuthenticatedTeacher(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user != null && "ROLE_TEACHER".equalsIgnoreCase(user.getRole())) {
            return user;
        }
        return null;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User teacher = getAuthenticatedTeacher(session);
        if (teacher == null) {
            return "redirect:/login";
        }

        List<Project> projects = projectService.findAllProjects();
        List<Deadline> deadlines = deadlineService.findAllDeadlines();

        long pendingCount = projects.stream().filter(p -> "PENDING".equalsIgnoreCase(p.getStatus())).count();
        long approvedCount = projects.stream().filter(p -> "APPROVED".equalsIgnoreCase(p.getStatus())).count();
        long rejectedCount = projects.stream().filter(p -> "REJECTED".equalsIgnoreCase(p.getStatus())).count();

        model.addAttribute("teacher", teacher);
        model.addAttribute("projects", projects);
        model.addAttribute("deadlines", deadlines);
        model.addAttribute("totalCount", projects.size());
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("approvedCount", approvedCount);
        model.addAttribute("rejectedCount", rejectedCount);

        return "teacher-dashboard";
    }

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam("projectId") Long projectId,
                               @RequestParam("status") String status,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User teacher = getAuthenticatedTeacher(session);
        if (teacher == null) {
            return "redirect:/login";
        }

        if (projectId != null && status != null) {
            String normalizedStatus = status.trim().toUpperCase();
            if ("APPROVED".equals(normalizedStatus) || "REJECTED".equals(normalizedStatus) || "PENDING".equals(normalizedStatus)) {
                projectService.updateProjectStatus(projectId, normalizedStatus);
                redirectAttributes.addFlashAttribute("successMessage",
                        "Project #" + projectId + " status updated to " + normalizedStatus + ".");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid status value specified.");
            }
        }

        return "redirect:/teacher/dashboard";
    }

    @GetMapping("/deadlines")
    public String viewDeadlines(HttpSession session, Model model) {
        User teacher = getAuthenticatedTeacher(session);
        if (teacher == null) {
            return "redirect:/login";
        }

        List<Deadline> deadlines = deadlineService.findAllDeadlines();
        model.addAttribute("teacher", teacher);
        model.addAttribute("deadlines", deadlines);
        model.addAttribute("subjects", DEFAULT_SUBJECTS);
        return "set-deadline";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                    return;
                }
                String[] patterns = new String[] {
                        "yyyy-MM-dd'T'HH:mm",
                        "yyyy-MM-dd'T'HH:mm:ss",
                        "yyyy-MM-dd HH:mm:ss",
                        "yyyy-MM-dd"
                };
                for (String pattern : patterns) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                        sdf.setLenient(false);
                        setValue(sdf.parse(text.trim()));
                        return;
                    } catch (ParseException ignored) {
                    }
                }
                throw new IllegalArgumentException("Could not parse date: " + text);
            }

            @Override
            public String getAsText() {
                Date value = (Date) getValue();
                return (value != null ? new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(value) : "");
            }
        });
    }

    @PostMapping("/deadlines")
    public String setDeadline(@RequestParam("subject") String subject,
                              @RequestParam("dueDate") Date dueDate,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User teacher = getAuthenticatedTeacher(session);
        if (teacher == null) {
            return "redirect:/login";
        }

        if (subject == null || subject.trim().isEmpty() || dueDate == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Subject and Due Date are both required.");
            return "redirect:/teacher/deadlines";
        }

        Deadline deadline = new Deadline(subject.trim(), dueDate);
        deadlineService.setOrUpdateDeadline(deadline);

        redirectAttributes.addFlashAttribute("successMessage",
                "Submission deadline for subject '" + subject.trim() + "' has been successfully set.");
        return "redirect:/teacher/deadlines";
    }

    @GetMapping("/download/{id}")
    public void downloadPdf(@PathVariable("id") Long id,
                           HttpServletResponse response,
                           HttpSession session) throws IOException {
        User teacher = getAuthenticatedTeacher(session);
        if (teacher == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Project project = projectService.findById(id);
        if (project == null || project.getDocumentPath() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found for this project.");
            return;
        }

        File file = new File(System.getProperty("user.dir") + "/uploads", project.getDocumentPath());
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document file does not exist on server.");
            return;
        }

        response.setContentType("application/pdf");
        String downloadName = project.getDocumentName() != null ? project.getDocumentName() : file.getName();
        response.setHeader("Content-Disposition", "inline; filename=\"" + downloadName + "\"");
        response.setContentLengthLong(file.length());

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }
}
