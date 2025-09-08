// assets/js/edu_map_hook.js
export const EduMap = {
  mounted() {
    this.map = L.map(this.el, { zoomControl: true, scrollWheelZoom: false });

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors"
    }).addTo(this.map);

    this.map.setView([43.716, 10.403], 6); // initial Pisa-ish view

    this.markersLayer = L.layerGroup().addTo(this.map);
    this.linesLayer = L.layerGroup().addTo(this.map);
    this.labelsLayer = L.layerGroup().addTo(this.map);

    this.handleEvent("edu:markers", ({ markers, view }) => {
      this.updateMarkers(markers, view);
    });

    requestAnimationFrame(() => this.map.invalidateSize());
  },

  updated() {
    this.map && this.map.invalidateSize();
  }, // <— keep this comma

  updateMarkers(markers, view) {
    this.markersLayer.clearLayers();
    this.linesLayer.clearLayers();
    this.labelsLayer.clearLayers();

    const bounds = [];
    (markers || []).forEach(m => {
      const p = L.latLng(m.lat, m.lng);
      bounds.push(p);

      L.marker(p).addTo(this.markersLayer);

      const offsetDeg = m.offset || { dlat: 0.6, dlng: 0.9 };
      const elbow = L.latLng(p.lat + offsetDeg.dlat * 0.6, p.lng + offsetDeg.dlng * 0.6);
      const labelPt = L.latLng(p.lat + offsetDeg.dlat, p.lng + offsetDeg.dlng);
      bounds.push(labelPt);

      L.polyline([p, elbow, labelPt], { weight: 2, opacity: 0.7 }).addTo(this.linesLayer);

      const labelIcon = L.divIcon({
        className: "leaflet-div-icon map-label",
        html: m.label || "",
        iconSize: null
      });
      L.marker(labelPt, { icon: labelIcon, interactive: false }).addTo(this.labelsLayer);
    });

    // If a view override is provided, use it; otherwise fit to markers.
    if (view?.center && typeof view.zoom === "number") {
      this.map.setView(view.center, view.zoom);
    } else if (view?.bounds && Array.isArray(view.bounds) && view.bounds.length === 2) {
      this.map.fitBounds(L.latLngBounds(view.bounds[0], view.bounds[1]), { padding: [30, 30] });
    } else if (bounds.length) {
      this.map.fitBounds(L.latLngBounds(bounds), { padding: [30, 30] });
    }
  }
};