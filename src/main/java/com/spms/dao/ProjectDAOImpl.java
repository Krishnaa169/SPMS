package com.spms.dao;

import com.spms.model.Project;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ProjectDAOImpl implements ProjectDAO {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void saveProject(Project project) {
        getSession().saveOrUpdate(project);
    }

    @Override
    public Project findById(Long id) {
        return getSession().get(Project.class, id);
    }

    @Override
    public List<Project> findByStudent(Long userId) {
        Query<Project> query = getSession().createQuery(
                "FROM Project p WHERE p.student.id = :userId ORDER BY p.submissionDate DESC", Project.class);
        query.setParameter("userId", userId);
        return query.list();
    }

    @Override
    public List<Project> findAllProjects() {
        Query<Project> query = getSession().createQuery(
                "FROM Project p ORDER BY p.submissionDate DESC", Project.class);
        return query.list();
    }

    @Override
    public void updateProjectStatus(Long id, String status) {
        Project project = findById(id);
        if (project != null) {
            project.setStatus(status);
            getSession().update(project);
        }
    }
}
