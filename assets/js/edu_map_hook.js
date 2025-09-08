export const EduMap = {
  mounted() {
    // Leaflet is loaded via CDN
    this.map = L.map(this.el, { zoomControl: true, scrollWheelZoom: false });

    this.tile = L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors"
    }).addTo(this.map);

    // Give it an initial view so tiles show even before markers arrive
    this.map.setView([43.716, 10.403], 6); // Pisa-ish

    this.markersLayer = L.layerGroup().addTo(this.map);
    this.linesLayer = L.layerGroup().addTo(this.map);
    this.labelsLayer = L.layerGroup().addTo(this.map);

    this.handleEvent("edu:markers", ({ markers }) => {
      this.updateMarkers(markers);
    });

    // Fix sizing glitches when the hook mounts
    requestAnimationFrame(() => this.map.invalidateSize());
  },

  updated() {
    this.map && this.map.invalidateSize();
  }, // <-- missing comma was here

  updateMarkers(markers) {
    this.markersLayer.clearLayers();
    this.linesLayer.clearLayers();
    this.labelsLayer.clearLayers();

    const bounds = [];
    markers.forEach(m => {
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

    if (bounds.length) {
      this.map.fitBounds(L.latLngBounds(bounds), { padding: [30, 30] });
    }
  }
};