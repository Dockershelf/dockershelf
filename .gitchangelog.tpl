% if data["title"]:
# ${data["title"]}
% endif

% for version in data["versions"]:

<% title = "## %s (%s)" % (version["tag"], version["date"]) if version["tag"] else "## %s" % opts["unreleased_version_label"] %>${title}
% for section in version["sections"]:

<% lbl = "### %s" % section["label"] %>${lbl}

% for commit in section["commits"]:
<%
author = commit["author"].replace('_', '\_')
subject = "%s [%s]" % (commit["subject"], author)
entry = indent(subject, first=" * ").strip()
%>${entry}

% endfor
% endfor
% endfor