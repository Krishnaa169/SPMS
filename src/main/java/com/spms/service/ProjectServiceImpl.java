package com.spms.service;

import com.spms.dao.ProjectDAO;
import com.spms.model.Project;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class ProjectServiceImpl implements ProjectService {

    @Autowired
    private ProjectDAO projectDAO;

    @Override
    public void saveProject(Project project) {
        if (project.getSubmissionDate() == null) {
            project.setSubmissionDate(new Date());
        }
        if (project.getStatus() == null || project.getStatus().trim().isEmpty()) {
            project.setStatus("PENDING");
        }
        projectDAO.saveProject(project);
    }

    @Override
    public Project findById(Long id) {
        return projectDAO.findById(id);
    }

    @Override
    public List<Project> findByStudent(Long userId) {
        return projectDAO.findByStudent(userId);
    }

    @Override
    public List<Project> findAllProjects() {
        return projectDAO.findAllProjects();
    }

    @Override
    public void updateProjectStatus(Long id, String status) {
        projectDAO.updateProjectStatus(id, status);
    }
}
