# Sprint M04 — Semantic Axes: Observations

**Dataset:** 266 world cities (`data/cities.csv`)  
**Model:** `sentence-transformers/all-MiniLM-L6-v2` (384-dim)  
**Team member(s):** Mutaz Al Darabseh, Pooyan Shalmashi, Benjamin Benson, Adam Horowitz

---

## Axes

### Semantic Axes (Plot 1 — `figs/semantic_map.png`)

| Axis | + pole | − pole | Interpretation |
|------|--------|--------|----------------|
| X (axis 1) | global financial hub, international business center, major economic capital, cosmopolitan metropolis, world city | small rural town, local community center, provincial town, remote settlement, low population town | **Global vs. Local** — how internationally connected and economically dominant a city is |
| Y (axis 2) | modern city, innovation hub, high-tech metropolis, smart city, contemporary urban center | historic city, ancient town, medieval settlement, old city center, classical heritage city | **Modern vs. Historic** — whether a city evokes contemporary innovation or deep historical roots |

**Cosine distances (quality check):**
- Axis 1: **0.738** ✓ (well above 0.30 threshold)
- Axis 2: **0.613** ✓ (well above 0.30 threshold)

### Data Axes (Plot 2 — `figs/geographic_map.png`)

| Axis | Column | Range | Std | Interpretation |
|------|--------|-------|-----|----------------|
| X | `lat` | −51.7° to +78.2° | 25.6° | **Hemisphere** — Southern cities left, Northern right |
| Y | `population` (log₁₀) | 1.7 – 7.4 | 1.13 decades | **City size** — tiny island capitals at bottom, Asian megacities at top |

---

## What separates along each axis?

**Semantic axis 1 (Global ↔ Local):** Cities such as New York, London, and Tokyo score strongly on the global side, reflecting their established roles in international finance and trade. Moving left on the axis, cities thin into regional trade hubs and domestic capitals that serve primarily local functions. The axis partially correlates with GaWC tier, confirming it captures the same latent dimension researchers operationalise through advanced-service-firm linkages.

**Semantic axis 2 (Modern ↔ Historic):** Cities associated with contemporary technological development and economic dynamism appear higher on the y-axis, while cities with deep medieval or ancient heritage anchor the lower end. The separation is meaningful but not sharp — many cities carry both identities.

**Latitude axis (Geographic plot):** The right half is dominated by European (blue) and Asian (purple) cities; the Americas (orange) split across both hemispheres. African cities (green) cluster near the equator (0°–20°N), reflecting continental geography. The northern cluster (lat > 55°) contains mostly moderate-sized European cities — London (51.5°N, Alpha++) is the northernmost truly global hub.

**Population axis (Geographic plot):** The top band is almost exclusively Asian — Delhi, Shanghai, Beijing, Guangzhou, and Shenzhen all exceed 15 million. European and American megacities occupy the upper-middle band. The bottom fringe is Oceania micro-capitals (Adamstown, West Island, Fakaofo) — orders of magnitude smaller than any other world city, yet classified as High Sufficiency GaWC nodes.

---

## Most surprising finding

**Paris and Rome appear on the modern side** of the semantic axis despite their historical identities. This reveals a key property of the embedding: it captures how cities are *described in present-day language*, not their founding dates. Both cities are overwhelmingly discussed in contemporary contexts — tourism, fashion, finance — which pulls their vectors toward the modern pole. This is an insight and a limitation simultaneously: the model encodes cultural salience stored in text, not objective historical depth.

A second surprise: **Monaco** ranks as the most "global" city on axis 1, ahead of New York and London. The embedding associates "Monaco" strongly with words like "international finance," "wealth," and "cosmopolitan" — reflecting its role as a tax haven and Formula 1 host more than its GaWC Gamma tier suggests.

---

## What would a third axis capture?

A **Coastal / Maritime Hub ↔ Landlocked / Interior City** axis (phrases such as "major seaport, maritime trade hub, harbour city" vs. "landlocked capital, interior city, inland settlement") would explain residual variance visible in both plots. Port cities — Singapore, Shanghai, Lagos, Istanbul — dominate global trade regardless of latitude or population size. This axis would separate them from landlocked capitals of equivalent GaWC tier (Astana, Lusaka, Kampala), revealing the structural role of sea access in shaping global connectivity independent of the axes already plotted.
