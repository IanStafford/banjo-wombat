#!/usr/bin/env python3
"""
plot_sensitivity.py — overlay I-V curves from a sensitivitySweep run.

Run from allNit/:
    python figures/sensitivity/plot_sensitivity.py
"""
import csv
import os
import sys
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np

INDEX   = "figures/sensitivity/sensitivity_index.csv"
OUT_DIR = "figures/sensitivity"


def read_iv(path):
    vds, ids = [], []
    try:
        with open(path) as f:
            reader = csv.DictReader(f)
            for row in reader:
                vds.append(float(row["Vds_V"]))
                ids.append(float(row["Id_uA_per_um"]))
    except (FileNotFoundError, KeyError, ValueError):
        pass
    return vds, ids


def main():
    if not os.path.exists(INDEX):
        sys.exit(f"Index not found: {INDEX}\n"
                 "Run sensitivitySweep.tcl first.")

    runs = []
    with open(INDEX) as f:
        for row in csv.DictReader(f):
            runs.append(row)

    if not runs:
        sys.exit("No runs in index — nothing to plot.")

    xs = [float(r["mean_x_um"]) for r in runs]
    ys = [float(r["mean_y_um"]) for r in runs]

    x_varies = len(set(xs)) > 1
    y_varies = len(set(ys)) > 1

    if y_varies and not x_varies:
        param_vals  = ys
        param_label = "Trap center y (µm)"
    elif x_varies and not y_varies:
        param_vals  = xs
        param_label = "Trap center x (µm)"
    else:
        # 2D grid — colour by y, annotate x
        param_vals  = ys
        param_label = "Trap center y (µm)"

    pmin, pmax = min(param_vals), max(param_vals)
    prange = pmax - pmin if pmax != pmin else 1.0
    cmap   = cm.viridis

    meta = runs[0]
    title_meta = (
        f"density={meta['trapDensity']}  σ={meta['trapSigma']} µm  "
        f"type={meta['trapType']}  energy={meta['trapEnergy']} eV"
    )

    fig, (ax_iv, ax_pk) = plt.subplots(1, 2, figsize=(13, 5))

    imax_list = []
    for run, pv in zip(runs, param_vals):
        ivpath = run["ivCSV"]
        vds, ids = read_iv(ivpath)
        if not ids:
            print(f"  Warning: no data in {ivpath}")
            imax_list.append(float("nan"))
            continue
        colour = cmap((pv - pmin) / prange)
        ax_iv.plot(vds, ids, color=colour, lw=1.5)
        imax_list.append(max(ids))

    # Colorbar
    sm = plt.cm.ScalarMappable(
        cmap=cmap, norm=plt.Normalize(pmin, pmax)
    )
    sm.set_array([])
    plt.colorbar(sm, ax=ax_iv, label=param_label)
    ax_iv.set_xlabel("Vds (V)")
    ax_iv.set_ylabel("Id (µA/µm)")
    ax_iv.set_title("I-V curves — sensitivity sweep")
    ax_iv.grid(True, alpha=0.3)

    # Peak Id vs swept parameter
    pairs = [(p, im) for p, im in zip(param_vals, imax_list)
             if im == im]               # drop NaN
    if pairs:
        pvs, ims = zip(*sorted(pairs))
        ax_pk.plot(pvs, ims, "o-", color="steelblue", lw=1.8, ms=6)
    ax_pk.set_xlabel(param_label)
    ax_pk.set_ylabel("Peak Id (µA/µm)")
    ax_pk.set_title("Peak drain current vs trap location")
    ax_pk.grid(True, alpha=0.3)

    fig.suptitle(title_meta, fontsize=9)
    plt.tight_layout()

    out_png = os.path.join(OUT_DIR, "sensitivity_iv_overlay.png")
    plt.savefig(out_png, dpi=150, bbox_inches="tight")
    print(f"Saved: {out_png}")

    # Also save per-parameter CSV summary
    summary_path = os.path.join(OUT_DIR, "sensitivity_summary.csv")
    with open(summary_path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["run", "mean_x_um", "mean_y_um", "peak_Id_uA_per_um"])
        for run, pv, im in zip(runs, param_vals, imax_list):
            w.writerow([run["run"], run["mean_x_um"], run["mean_y_um"],
                        "" if im != im else f"{im:.4f}"])
    print(f"Saved: {summary_path}")

    plt.show()


if __name__ == "__main__":
    main()
