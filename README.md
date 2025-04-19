# Cadet Management System

## Overview
This application is a comprehensive Cadet Management System, designed for a military institution. It manages various aspects of cadet life, with a particular focus on medical care and administrative processes.

## Key Features

1. **Cadet Information Management**
   - Stores detailed information about cadets, including personal details, enlistment dates, and academic affiliations.
   - Tracks cadets' departmental and battalion assignments.

2. **Medical Care System**
   - Records and manages medical visits and treatments for cadets.
   - Tracks diagnoses, prescriptions, and medical excuses.
   - Monitors admission counts and confinement days.

3. **Staff Management**
   - Manages information about staff members, including medical personnel.
   - Supports different roles and appointments within the institution.

4. **Organizational Structure**
   - Represents the academy's structure with faculties, departments, and battalions.
   - Manages course information and cadet assignments to regular courses.

5. **Visit Management**
   - Tracks cadet visits to medical facilities, including check-in times and reasons.
   - Assigns doctors to specific visits.

6. **Automated Status Updates**
   - Automatically updates cadets' board status based on cumulative medical days.
   - Tracks admission counts and dates.

7. **User Authentication**
   - Includes user authentication for staff members.

## Technical Details

- Built using SQLAlchemy ORM with Flask framework.
- Utilizes Flask-Migrate for database migrations.
- Implements relationships between various entities for efficient data management.
- Includes data validation and integrity checks.

## Potential Use Cases

1. Medical staff can track and manage cadet health records.
2. Administrators can monitor cadet statuses and assignments.
3. Faculty can access academic information about cadets.
4. Reporting tools for generating statistics on cadet health and academic performance.
5. Managing staff assignments and roles within the institution.
