package com.spms.controller;

import com.spms.model.Deadline;
import com.spms.model.Project;
import com.spms.model.User;
import com.spms.service.DeadlineService;
import com.spms.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

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

    private User getAuthenticatedStudent(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user != null && "ROLE_STUDENT".equalsIgnoreCase(user.getRole())) {
            return user;
        }
        return null;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User student = getAuthenticatedStudent(session);
        if (student == null) {
            return "redirect:/login";
        }

        List<Project> projects = projectService.findByStudent(student.getId());
        List<Deadline> deadlines = deadlineService.findAllDeadlines();

        model.addAttribute("student", student);
        model.addAttribute("projects", projects);
        model.addAttribute("deadlines", deadlines);
        return "student-dashboard";
    }

    @GetMapping("/submit")
    public String showSubmitForm(HttpSession session, Model model) {
        User student = getAuthenticatedStudent(session);
        if (student == null) {
            return "redirect:/login";
        }

        if (!model.containsAttribute("project")) {
            model.addAttribute("project", new Project());
        }
        model.addAttribute("subjects", DEFAULT_SUBJECTS);
        model.addAttribute("deadlines", deadlineService.findAllDeadlines());
        return "submit-project";
    }

    @PostMapping("/submit")
    public String submitProject(@Valid @ModelAttribute("project") Project project,
                                BindingResult bindingResult,
                                @RequestParam(value = "pdfFile", required = false) MultipartFile pdfFile,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        User student = getAuthenticatedStudent(session);
        if (student == null) {
            return "redirect:/login";
        }

        // Check if submission deadline has passed for the subject
        if (project.getSubject() != null && !project.getSubject().trim().isEmpty()) {
            boolean allowed = deadlineService.isSubmissionAllowed(project.getSubject());
            if (!allowed) {
                Deadline deadline = deadlineService.getDeadlineBySubject(project.getSubject());
                String formattedDate = deadline != null && deadline.getDueDate() != null
                        ? new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(deadline.getDueDate())
                        : "Past cutoff date";
                bindingResult.rejectValue("subject", "error.project",
                        "The submission deadline (" + formattedDate + ") for " + project.getSubject() + " has passed! Submissions are now closed.");
            }
        }

        // Validate PDF upload if provided
        if (pdfFile != null && !pdfFile.isEmpty()) {
            String originalName = pdfFile.getOriginalFilename();
            if (originalName == null || !originalName.toLowerCase().endsWith(".pdf")) {
                model.addAttribute("fileError", "Only PDF documents (.pdf) are accepted.");
                bindingResult.rejectValue("description", "error.project", "Uploaded documentation file must be in PDF format.");
            }
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("subjects", DEFAULT_SUBJECTS);
            model.addAttribute("deadlines", deadlineService.findAllDeadlines());
            model.addAttribute("errorMessage", "Please correct the errors in the form before submitting.");
            return "submit-project";
        }

        // Save PDF file if attached
        if (pdfFile != null && !pdfFile.isEmpty()) {
            try {
                File uploadsDir = new File(System.getProperty("user.dir"), "uploads");
                if (!uploadsDir.exists()) {
                    uploadsDir.mkdirs();
                }

                String originalName = pdfFile.getOriginalFilename();
                String sanitizedName = originalName != null ? originalName.replaceAll("[^a-zA-Z0-9._-]", "_") : "document.pdf";
                String savedFileName = System.currentTimeMillis() + "_" + sanitizedName;
                File targetFile = new File(uploadsDir, savedFileName);

                pdfFile.transferTo(targetFile);

                project.setDocumentPath(savedFileName);
                project.setDocumentName(originalName != null ? originalName : savedFileName);
            } catch (IOException e) {
                model.addAttribute("subjects", DEFAULT_SUBJECTS);
                model.addAttribute("deadlines", deadlineService.findAllDeadlines());
                model.addAttribute("errorMessage", "Failed to save uploaded PDF file: " + e.getMessage());
                return "submit-project";
            }
        }

        project.setStudent(student);
        project.setSubmissionDate(new Date());
        project.setStatus("PENDING");
        projectService.saveProject(project);

        redirectAttributes.addFlashAttribute("successMessage",
                "Project '" + project.getTitle() + "' and its documentation have been submitted successfully!");
        return "redirect:/student/dashboard";
    }

    @GetMapping("/download/{id}")
    public void downloadPdf(@PathVariable("id") Long id,
                           HttpServletResponse response,
                           HttpSession session) throws IOException {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Project project = projectService.findById(id);
        if (project == null || project.getDocumentPath() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found for this project.");
            return;
        }

        // Students can only view/download their own project
        if ("ROLE_STUDENT".equalsIgnoreCase(user.getRole()) && !project.getStudent().getId().equals(user.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
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
