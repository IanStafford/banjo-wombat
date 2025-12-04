import re
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

def parse_data_file(filepath):
    """
    Parse the data file with format:
    {   Distance     Value   Material }
    { value1    value2    Material }
    ...
    """
    datasets = []
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Split by header lines (containing "Distance", "Value", "Material")
    sections = re.split(r'\{\s*Distance\s+Value\s+Material\s*\}', content)
    
    for section in sections[1:]:  # Skip the first empty split
        distances = []
        values = []
        materials = []
        
        # Find all data lines
        lines = section.strip().split('\n')
        for line in lines:
            if line.strip().startswith('{') and line.strip().endswith('}'):
                # Extract numbers from the curly braces
                match = re.findall(r'([+-]?\d\.?\d*[eE][+-]?\d+|[+-]?\d+\.\d+)', line)
                if len(match) >= 2:
                    try:
                        dist = float(match[0])
                        val = float(match[1])
                        distances.append(dist)
                        values.append(val)
                        materials.append(line.split()[-1])
                    except ValueError:
                        continue
        
        if distances:
            datasets.append({
                'distance': np.array(distances),
                'value': np.array(values),
                'material': materials[0] if materials else 'Unknown'
            })
    
    return datasets

def plot_datasets(datasets, output_path=None):
    """
    Plot all datasets in a grid layout
    """
    n_datasets = len(datasets)
    n_cols = 2
    n_rows = (n_datasets + n_cols - 1) // n_cols
    
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(14, 4*n_rows))
    if n_datasets == 1:
        axes = [axes]
    else:
        axes = axes.flatten()
    
    for idx, dataset in enumerate(datasets):
        ax = axes[idx]
        
        distance = dataset['distance']
        value = dataset['value']
        material = dataset['material']
        
        ax.plot(distance, value, 'b-', linewidth=1.5, label=material)
        ax.set_xlabel('Distance', fontsize=10)
        ax.set_ylabel('Value', fontsize=10)
        ax.set_title(f'Dataset {idx+1} - {material}', fontsize=11, fontweight='bold')
        ax.grid(True, alpha=0.3)
        ax.legend(loc='best')
        
        # Use scientific notation for both axes if needed
        if abs(distance).max() > 1e3 or (abs(distance).min() < 1e-3 and abs(distance).min() > 0):
            ax.ticklabel_format(style='sci', axis='x', scilimits=(0, 0))
        if abs(value).max() > 1e3 or (abs(value).min() < 1e-3 and abs(value).min() > 0):
            ax.ticklabel_format(style='sci', axis='y', scilimits=(0, 0))
    
    # Hide extra subplots
    for idx in range(n_datasets, len(axes)):
        axes[idx].set_visible(False)
    
    plt.tight_layout()
    
    if output_path:
        plt.savefig(output_path, dpi=150, bbox_inches='tight')
        print(f"Plot saved to {output_path}")
    
    plt.show()

def plot_overlay(datasets, output_path=None):
    """
    Plot all datasets on top of each other for comparison
    """
    fig, ax = plt.subplots(figsize=(12, 6))
    
    colors = plt.cm.tab10(np.linspace(0, 1, len(datasets)))
    
    for idx, dataset in enumerate(datasets):
        distance = dataset['distance']
        value = dataset['value']
        material = dataset['material']
        
        ax.plot(distance, value, linewidth=2, color=colors[idx], 
                label=f'Dataset {idx+1} - {material}', alpha=0.8)
    
    ax.set_xlabel('Distance', fontsize=12, fontweight='bold')
    ax.set_ylabel('Value', fontsize=12, fontweight='bold')
    ax.set_title('Overlay of All Datasets', fontsize=13, fontweight='bold')
    ax.grid(True, alpha=0.3)
    ax.legend(loc='best', fontsize=10)
    
    plt.tight_layout()
    
    if output_path:
        plt.savefig(output_path, dpi=150, bbox_inches='tight')
        print(f"Overlay plot saved to {output_path}")
    
    plt.show()


def plot_dataset_csv(csv_path, ax=None, figsize=(8, 5), xlabel='Distance', ylabel='Value',
                     title=None, show=True, save_path=None, line_kwargs=None):
    """
    Plot a single dataset from a CSV file with header 'Distance,Value'.

    Parameters
    - csv_path: path to the CSV file
    - ax: optional matplotlib Axes to draw onto. If None, a new figure is created.
    - figsize: size for new figure (only used if ax is None)
    - title: optional title for the plot
    - show: whether to call plt.show()
    - save_path: if provided, the plot is saved to this path
    - line_kwargs: dict of kwargs forwarded to ax.plot

    Returns the Axes instance containing the plot.
    """
    csv_path = Path(csv_path)
    if not csv_path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")

    data = np.loadtxt(csv_path, delimiter=',', skiprows=1)
    if data.ndim == 1 and data.size == 0:
        raise ValueError(f"No data loaded from {csv_path}")

    x = data[:, 0]
    y = data[:, 1]

    created_fig = False
    if ax is None:
        fig, ax = plt.subplots(figsize=figsize)
        created_fig = True

    lw = {'linewidth': 1.8}
    if line_kwargs:
        lw.update(line_kwargs)

    ax.plot(x, y, **lw)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    if title:
        ax.set_title(title)
    ax.grid(True, alpha=0.3)

    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches='tight')
        print(f"Saved plot to {save_path}")

    if show:
        plt.show()

    return ax


def plot_dataset_index(datasets, dataset_number, ax=None, figsize=(8, 5), xlabel='Distance',
                       ylabel='Value', title=None, show=True, save_path=None, line_kwargs=None):
    """
    Plot a single dataset from the in-memory parsed datasets list.

    Parameters
    - datasets: list as returned by parse_data_file
    - dataset_number: 1-based dataset index (1 => first dataset)
    - other args: same as plot_dataset_csv

    Returns the Axes instance.
    """
    if dataset_number < 1 or dataset_number > len(datasets):
        raise IndexError(f"dataset_number out of range: {dataset_number}")

    dataset = datasets[dataset_number - 1]
    x = dataset['distance']
    y = dataset['value']
    material = dataset.get('material', 'Unknown')

    created_fig = False
    if ax is None:
        fig, ax = plt.subplots(figsize=figsize)
        created_fig = True

    lw = {'linewidth': 1.8}
    if line_kwargs:
        lw.update(line_kwargs)

    ax.plot(x, y, **lw)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_title(title or f'Dataset {dataset_number} - {material}')
    ax.grid(True, alpha=0.3)

    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches='tight')
        print(f"Saved dataset {dataset_number} plot to {save_path}")

    if show:
        plt.show()

    return ax

def save_datasets_to_csv(datasets, output_dir, num_datasets=4):
    """
    Save the first N datasets to separate CSV files
    """
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    for idx, dataset in enumerate(datasets[:num_datasets]):
        distance = dataset['distance']
        value = dataset['value']
        material = dataset['material']
        
        # Create output filename
        filename = output_dir / f'dataset_{idx+1}_{material}.csv'
        
        # Save to CSV with headers
        data = np.column_stack((distance, value))
        np.savetxt(filename, data, delimiter=',', header='Distance,Value', comments='')
        
        print(f"Saved Dataset {idx+1} to {filename}")

if __name__ == '__main__':
    # Path to the data file
    data_file = Path(__file__).parent / 'figures' / 'acceptor_GaN_AlGaN_6_AcceptorTrapOccupation_Vgm2.csv'
    
    print(f"Reading data from: {data_file}")
    
    # Parse the data
    datasets = parse_data_file(data_file)
    print(f"Found {len(datasets)} datasets")
    
    # Print summary statistics
    for idx, dataset in enumerate(datasets):
        print(f"\nDataset {idx+1} ({dataset['material']}):")
        print(f"  Distance range: [{dataset['distance'].min():.6e}, {dataset['distance'].max():.6e}]")
        print(f"  Value range: [{dataset['value'].min():.6e}, {dataset['value'].max():.6e}]")
        print(f"  Number of points: {len(dataset['distance'])}")
    
    # Save first 4 datasets to separate CSV files
    print("\n" + "="*60)
    print("Saving first 4 datasets to CSV files...")
    print("="*60)
    save_datasets_to_csv(datasets, Path(__file__).parent / 'figures', num_datasets=4)
    
    # Create plots
    print("\n" + "="*60)
    print("Generating plots...")
    print("="*60)
    plot_datasets(datasets, output_path=Path(__file__).parent / 'figures' / 'plot_grid.png')
    plot_overlay(datasets, output_path=Path(__file__).parent / 'figures' / 'plot_overlay.png')

    # ------------------------------------------------------------------
    # Example: plot single datasets (2, 3, 4) individually using the
    # helper functions added above. These create PNGs in the figures/
    # directory if the datasets exist.
    # ------------------------------------------------------------------
    figures_dir = Path(__file__).parent / 'figures'
    for n in (2, 3, 4):
        if len(datasets) >= n:
            # Plot directly from in-memory datasets
            out_png = figures_dir / f'dataset_{n}.png'
            try:
                plot_dataset_index(datasets, n, show=False, save_path=out_png)
            except Exception as e:
                print(f"Failed to plot dataset {n} from memory: {e}")

            # Also demonstrate plotting from the saved CSV (if present)
            material = datasets[n-1].get('material', 'Unknown')
            csv_file = figures_dir / f'dataset_{n}_{material}.csv'
            if csv_file.exists():
                out_csv_png = figures_dir / f'dataset_{n}_from_csv.png'
                try:
                    plot_dataset_csv(csv_file, show=False, save_path=out_csv_png)
                except Exception as e:
                    print(f"Failed to plot dataset {n} from CSV {csv_file}: {e}")
        else:
            print(f"Dataset {n} not available (only {len(datasets)} found)")
