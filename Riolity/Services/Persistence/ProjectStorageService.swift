import Foundation

class ProjectStorageService {
    static let shared = ProjectStorageService()

    private let projectsKey = "riolity_saved_projects"
    private let userDefaults = UserDefaults.standard

    private init() {}

    func saveProject(_ project: DesignProject) {
        var projects = loadProjects()

        // Remove existing project with same ID if exists
        projects.removeAll { $0.id == project.id }

        // Add new/updated project
        projects.insert(project, at: 0)

        saveProjects(projects)
    }

    func loadProjects() -> [DesignProject] {
        guard let data = userDefaults.data(forKey: projectsKey) else {
            return []
        }

        do {
            let projects = try JSONDecoder().decode([DesignProject].self, from: data)
            return projects
        } catch {
            print("Error loading projects: \(error)")
            return []
        }
    }

    func deleteProject(_ project: DesignProject) {
        var projects = loadProjects()
        projects.removeAll { $0.id == project.id }
        saveProjects(projects)
    }

    func deleteProject(byId id: UUID) {
        var projects = loadProjects()
        projects.removeAll { $0.id == id }
        saveProjects(projects)
    }

    private func saveProjects(_ projects: [DesignProject]) {
        do {
            let data = try JSONEncoder().encode(projects)
            userDefaults.set(data, forKey: projectsKey)
        } catch {
            print("Error saving projects: \(error)")
        }
    }

    func getProject(byId id: UUID) -> DesignProject? {
        loadProjects().first { $0.id == id }
    }

    func projectCount() -> Int {
        loadProjects().count
    }

    func clearAllProjects() {
        userDefaults.removeObject(forKey: projectsKey)
    }
}
