const Set<String> _trustedMediaHosts = {
  'ganjoor.net',
  'api.ganjoor.net',
  'media.ganjoor.net',
  'dl.ganjoor.net',
};

bool isTrustedMediaUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.host.isEmpty) return false;
  if (uri.scheme != 'https') return false;
  final host = uri.host.toLowerCase();
  return _trustedMediaHosts.any(
    (allowed) => host == allowed || host.endsWith('.$allowed'),
  );
}
