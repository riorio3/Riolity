import SwiftUI

struct ProjectsGalleryView: View {
    @State private var projects: [DesignProject] = []
    @State private var selectedProject: DesignProject?
    @State private var showingProjectDetail = false

    var body: some View {
        ZStack {
            RetroTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    RetroHeader(text: "MY PROJECTS", size: 18)
                    TerminalText(text: "\(projects.count) saved designs", size: 12, color: RetroTheme.dimGreen)
                }
                .padding(.top, 12)
                .padding(.bottom, 16)

                if projects.isEmpty {
                    emptyState
                } else {
                    projectsList
                }
            }

            ScanlineOverlay()
                .ignoresSafeArea()
        }
        .onAppear {
            loadProjects()
        }
        .sheet(isPresented: $showingProjectDetail) {
            if let project = selectedProject {
                ProjectDetailView(project: project, onDelete: {
                    deleteProject(project)
                    showingProjectDetail = false
                })
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(RetroTheme.dimGreen)

            VStack(spacing: 8) {
                TerminalText(text: "NO PROJECTS YET", size: 16, color: RetroTheme.dimGreen)
                TerminalText(text: "Create a design in the Design tab", size: 13, color: RetroTheme.darkGreen)
                TerminalText(text: "and save it to see it here", size: 13, color: RetroTheme.darkGreen)
            }

            Spacer()
        }
    }

    private var projectsList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(projects) { project in
                    ProjectCard(project: project) {
                        selectedProject = project
                        showingProjectDetail = true
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
    }

    private func loadProjects() {
        projects = ProjectStorageService.shared.loadProjects()
    }

    private func deleteProject(_ project: DesignProject) {
        ProjectStorageService.shared.deleteProject(project)
        loadProjects()
    }
}

struct ProjectCard: View {
    let project: DesignProject
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                // Mini 3D preview placeholder
                ZStack {
                    RetroTheme.darkGreen.opacity(0.3)

                    Image(systemName: "cube.fill")
                        .font(.system(size: 30))
                        .foregroundColor(RetroTheme.dimGreen)
                }
                .frame(height: 100)
                .retroBorder(color: RetroTheme.darkGreen)

                // Project info
                VStack(alignment: .leading, spacing: 4) {
                    TerminalText(text: project.displayName, size: 12)
                        .lineLimit(1)

                    TerminalText(text: project.categoryName, size: 10, color: RetroTheme.dimGreen)

                    TerminalText(text: project.dateString, size: 9, color: RetroTheme.darkGreen)
                }

                // Properties preview
                HStack {
                    TerminalText(text: project.design.properties.porosityPercent, size: 10, color: RetroTheme.dimGreen)
                    Spacer()
                    TerminalText(text: project.design.algorithmName, size: 9, color: RetroTheme.darkGreen)
                }
            }
            .padding(10)
            .background(RetroTheme.darkGreen.opacity(0.2))
            .retroBorder(color: RetroTheme.dimGreen)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
