% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resp-body-pbf.R
\name{resp_body_pbf}
\alias{resp_body_pbf}
\alias{resps_data_pbf}
\title{Extract PBFs from httr2_response objects}
\usage{
resp_body_pbf(resp, post_process = TRUE, use_sf = TRUE)

resps_data_pbf(resps, post_process = TRUE, use_sf = TRUE)
}
\arguments{
\item{resp}{A httr2 \link[httr2]{response} object, created by \code{\link[httr2:req_perform]{req_perform()}}.}

\item{post_process}{default \code{TRUE}. Apply \code{post_process_pbf()} to the
pbf body.}

\item{use_sf}{default \code{TRUE}. Whether or not to return an \code{sf} object.}

\item{resps}{a list of \code{httr2_response} objects such as
created by \code{httr2::req_perform_parallel()}}
}
\value{
A processed FeatureCollection pbf. Either a scalar integer, named list,
data.frame, or an sf object if post-processing is applied.
}
\description{
Processes \code{httr2_response} objects that return FeatureCollection PBFs.
}
\details{
Responses of type \code{application/x-protobuf} are automatically processed using
\code{process_pbf()} with optional post-processing applied. Theses functions
assume that the body of the responses are an Esri FeatureCollection
protocol buffer.
\subsection{Lists of responses}{

When running multiple requests in parallel using
\code{\link[httr2:req_perform_parallel]{httr2::req_perform_parallel()}} the responses are returned as a list of
responses. \code{resps_data_pbf()} processes the responses in a vectorized
manner.

Results are post-processed by default and return sf objects if applicable.
This may not be desirable if heterogeneous response types are expected. For
example, if one list element contains a count result and another contains
an object ID result.

See \code{\link[=post_process_pbf]{post_process_pbf()}} for more details.

Note: Knowledge Graph protocol buffers and other protobuf formats are not supported
and will result in an error if used with these functions.
}
}
\examples{

if (rlang::is_installed(c("httr2", "sf")) && interactive()) {
  base_url <- file.path(
    "https://services.arcgis.com/P3ePLMYs2RVChkJx",
    "arcgis", "rest", "services",
    "ACS_Population_by_Race_and_Hispanic_Origin_Boundaries",
    "FeatureServer", "2", "query",
    fsep = "/"
  )

  # create the base request
  req <- httr2::request(base_url)

  # fill query parameters
  req <- httr2::req_url_query(
    req,
    where = "1=1",
    outFeilds = "objectid",
    resultRecordCount = 1,
    f = "pbf"
  )

  # make the request
  resp <- httr2::req_perform(req)

  # parse the request
  resp_body_pbf(resp)

  # simulate response from multi_req_perform
  resps <- list(resp, resp, resp)

  # process them all at once
  resps_data_pbf(resps)
}
}
