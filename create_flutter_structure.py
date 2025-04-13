import os

structure = {
    "core": {
        "constants": ["app_constants.dart"],
        "errors": ["failures.dart"],
        "router": ["app_router.dart"],
        "theme": ["app_theme.dart"],
        "utils": ["location_utils.dart"]
    },
    "data": {
        "datasources": ["location_datasource.dart", "ride_datasource.dart"],
        "models": ["location_model.dart", "ride_request_model.dart"],
        "repositories": ["location_repository_impl.dart", "ride_repository_impl.dart"]
    },
    "domain": {
        "entities": ["location_entity.dart", "ride_request_entity.dart"],
        "repositories": ["location_repository.dart", "ride_repository.dart"],
        "usecases": ["get_current_location.dart", "get_route.dart", "submit_ride_request.dart"]
    },
    "presentation": {
        "blocs": {
            "location": ["location_bloc.dart", "location_event.dart", "location_state.dart"],
            "ride": ["ride_bloc.dart", "ride_event.dart", "ride_state.dart"]
        },
        "pages": [
            "home_page.dart",
            "location_selection_page.dart",
            "ride_confirmation_page.dart",
            "ride_details_page.dart"
        ],
        "widgets": [
            "location_input_widget.dart",
            "map_widget.dart",
            "passenger_counter_widget.dart",
            "ride_details_form.dart"
        ]
    }
}

def create_structure(base_path, structure):
    try:
        for folder, content in structure.items():
            folder_path = os.path.join(base_path, folder)
            os.makedirs(folder_path, exist_ok=True)
            print(f"Created directory: {folder_path}")  # Лог для отслеживания
            if isinstance(content, dict):
                create_structure(folder_path, content)
            elif isinstance(content, list):
                for file in content:
                    file_path = os.path.join(folder_path, file)
                    with open(file_path, 'w') as f:
                        f.write("// " + file)  # Пишем заглушку
                    print(f"Created file: {file_path}")  # Лог для отслеживания
    except Exception as e:
        print(f"Error: {e}")

# Проверьте, существует ли базовая директория
base_directory = "/Users/dmitrymagadya/StudioProjects/demo_ride_booker/lib"
if not os.path.exists(base_directory):
    print(f"Base directory does not exist: {base_directory}")
else:
    create_structure(base_directory, structure)
