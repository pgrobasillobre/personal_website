export const EduMap = {
  mounted() {
    // Leaflet is loaded via CDN
    this.map = L.map(this.el, { zoomControl: true, scrollWheelZoom: false });
    this.tile = L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors"
    }).addTo(this.map);

    this.markersLayer = L.layerGroup().addTo(this.map);
    this.linesLayer = L.layerGroup().addTo(this.map);
    this.labelsLayer = L.layerGroup().addTo(this.map);

    // Receive marker updates from the server
    this.handleEvent("edu:markers", ({ markers }) => {
      this.updateMarkers(markers);
    });
  },

  updateMarkers(markers) {
    this.markersLayer.clearLayers();
    this.linesLayer.clearLayers();
    this.labelsLayer.clearLayers();

    const bounds = [];
    markers.forEach(m => {
      const p = L.latLng(m.lat, m.lng);
      bounds.push(p);

      // Marker
      L.marker(p).addTo(this.markersLayer);

      // Create a small offset for the label to draw an inclined line → horizontal leader
      const offsetDeg = m.offset || { dlat: 0.6, dlng: 0.9 };
      const elbow = L.latLng(p.lat + offsetDeg.dlat * 0.6, p.lng + offsetDeg.dlng * 0.6);
      const labelPt = L.latLng(p.lat + offsetDeg.dlat, p.lng + offsetDeg.dlng);
      bounds.push(labelPt);

      // Slanted + short horizontal line
      L.polyline([p, elbow, labelPt], { weight: 2, opacity: 0.7 }).addTo(this.linesLayer);

      // Label
      const labelIcon = L.divIcon({
        className: "leaflet-div-icon map-label",
        html: m.label || "",
        iconSize: null
      });
      L.marker(labelPt, { icon: labelIcon, interactive: false }).addTo(this.labelsLayer);
    });

    if (bounds.length) {
      this.map.fitBounds(L.latLngBounds(bounds), { padding: [30, 30] });
    } else {
      this.map.setView([43.7, 10.4], 6); // fallback: Pisa-ish
    }
  }
};