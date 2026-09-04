import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer


PORT = int(os.getenv("PORT", "8080"))


class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            response = {
                "status": "healthy",
                "service": "azure-terraform-platform"
            }
            status_code = 200
        else:
            response = {
                "message": "Azure Terraform Platform API",
                "health": "/health"
            }
            status_code = 200

        body = json.dumps(response).encode("utf-8")

        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


server = HTTPServer(("0.0.0.0", PORT), RequestHandler)

print(f"Server listening on port {PORT}", flush=True)
server.serve_forever()