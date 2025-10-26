use sysinfo::Components;

fn main() {
    let components = Components::new_with_refreshed_list();
    for component in &components {
        let label = component.label();

        if label == "coretemp Package id 0" {

            if let Some(temperature) = component.temperature() {
                println!("{temperature}");
            } else {
                println!("{} (unknown temperature)", component.label());
            }

        }

    }

}
