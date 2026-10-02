package com.spms.dao;

import com.spms.model.Project;
import java.util.List;

public interface ProjectDAO {
    void saveProject(Project project);
    Project findById(Long id);
    List<Project> findByStudent(Long userId);
    List<Project> findAllProjects();
    void updateProjectStatus(Long id, String status);
}
