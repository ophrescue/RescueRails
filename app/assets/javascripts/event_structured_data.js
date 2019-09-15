{
  "@context": "http://schema.org",
  "@type": "Event",
  "location": {
    "@type": "Place",
    "address": {
      "@type": "PostalAddress",
      "addressLocality": "<%= @event.address.split(',')[1].strip %>",
      "addressRegion": "<%= @event.address.split(',')[2].split(' ')[0]%>",
      "postalCode": "<%= @event.address.split(',')[2].split(' ')[1]%>",
      "streetAddress": "<%= @event.address.split(',')[0] %>"
    },
    "name": "<%= @event.location_name %>"
  },
  "name": "<%= @event.title %>",
  "startDate": "<%= @event.start_time.utc %>"
}
