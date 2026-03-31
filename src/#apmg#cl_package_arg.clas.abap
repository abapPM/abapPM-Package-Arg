CLASS /apmg/cl_package_arg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

************************************************************************
* Package Arg
*
* Copyright 2025 apm.to Inc. <https://apm.to>
* SPDX-License-Identifier: MIT
************************************************************************
* Similar to npm-package-arg
* https://www.npmjs.com/package/npm-package-arg
************************************************************************
  PUBLIC SECTION.

    " https://github.com/npm/npm-package-arg/blob/main/lib/npa.js
    METHODS constructor
      IMPORTING
        !arg TYPE any.

    METHODS get
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

    METHODS to_string
      RETURNING
        VALUE(result) TYPE string.

    METHODS to_purl
      IMPORTING
        !arg          TYPE string
        !registry     TYPE string DEFAULT 'https://registry.abappm.com'
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

    METHODS resolve
      IMPORTING
        !name         TYPE string
        !spec         TYPE string
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA npa TYPE /apmg/if_package_arg=>ty_result.

ENDCLASS.



CLASS /apmg/cl_package_arg IMPLEMENTATION.


  METHOD constructor.

    DATA arg_string TYPE string.
    DATA name TYPE string.
    DATA spec TYPE string.
    DATA name_ends_at TYPE i VALUE -1.

    arg_string = arg.

    IF arg_string IS INITIAL.
      RETURN.
    ENDIF.

    " Skip possible leading @ for scoped packages
    IF strlen( arg_string ) > 1.
      DATA(rest) = substring( val = arg_string off = 1 ).
      DATA(at_pos) = find( val = rest sub = '@' ).
      IF at_pos >= 0.
        name_ends_at = at_pos + 1.
      ENDIF.
    ENDIF.

    IF name_ends_at > 0.
      name = substring( val = arg_string len = name_ends_at ).
      spec = substring( val = arg_string off = name_ends_at + 1 ).
      IF spec IS INITIAL.
        spec = '*'.
      ENDIF.
    ELSE.
      name = arg_string.
      spec = '*'.
    ENDIF.

    npa = resolve( name = name spec = spec ).
    npa-raw = arg_string.

  ENDMETHOD.


  METHOD get.

    result = npa.

  ENDMETHOD.


  METHOD resolve.

    DATA spec_local TYPE string.

    spec_local = spec.
    IF spec_local IS INITIAL.
      spec_local = '*'.
    ENDIF.

    IF name IS NOT INITIAL.
      result-raw = |{ name }@{ spec_local }|.
    ELSE.
      result-raw = spec_local.
    ENDIF.

    result-raw_spec = spec.

    IF name IS NOT INITIAL.
      result-name = name.
      IF name CP '@*'.
        DATA(slash_pos) = find( val = name sub = '/' ).
        IF slash_pos >= 0.
          result-scope = substring( val = name len = slash_pos ).
        ENDIF.
      ENDIF.
      result-escaped_name = name.
      REPLACE ALL OCCURRENCES OF `/` IN result-escaped_name WITH `%2f`.
    ENDIF.

    result-registry = abap_true.
    result-save_spec = ``.
    DATA(spec_trimmed) = condense( spec_local ).
    result-fetch_spec = spec_trimmed.

    FIND REGEX '^\d+\.\d+\.\d+(-[\w.]+)?(\+[\w.]+)?$' IN spec_trimmed ##REGEX_POSIX.
    IF sy-subrc = 0.
      result-type = 'version'.
      RETURN.
    ENDIF.

    FIND REGEX '[><=~^|]' IN spec_trimmed ##REGEX_POSIX.
    IF sy-subrc = 0.
      result-type = 'range'.
      RETURN.
    ENDIF.

    IF spec_trimmed = '*' OR spec_trimmed = 'x' OR spec_trimmed = 'X'.
      result-type = 'range'.
      RETURN.
    ENDIF.

    FIND REGEX '^\d+(\.\d+)?(\.[xX*])?$' IN spec_trimmed ##REGEX_POSIX.
    IF sy-subrc = 0.
      result-type = 'range'.
      RETURN.
    ENDIF.

    FIND REGEX '\d\s+-\s+\d' IN spec_trimmed ##REGEX_POSIX.
    IF sy-subrc = 0.
      result-type = 'range'.
      RETURN.
    ENDIF.

    result-type = 'tag'.

  ENDMETHOD.


  METHOD to_purl.

    DATA(lo_npa) = NEW /apmg/cl_package_arg( arg ).

    result = lo_npa->get( ).

    IF result-type <> 'version'.
      RETURN.
    ENDIF.

    DATA(purl_name) = result-name.
    IF purl_name CP '@*'.
      purl_name = '%40' && substring( val = purl_name off = 1 ).
    ENDIF.

    result-purl = |pkg:apm/{ purl_name }@{ result-raw_spec }|.
    IF registry <> 'https://registry.abappm.com'.
      result-purl = result-purl && |?repository_url={ registry }|.
    ENDIF.

  ENDMETHOD.


  METHOD to_string.

    DATA local_spec TYPE string.

    IF npa-save_spec IS NOT INITIAL.
      local_spec = npa-save_spec.
    ELSEIF npa-fetch_spec IS NOT INITIAL.
      local_spec = npa-fetch_spec.
    ELSEIF npa-raw_spec IS NOT INITIAL.
      local_spec = npa-raw_spec.
    ELSE.
      local_spec = ''.
    ENDIF.

    IF npa-name IS NOT INITIAL AND local_spec IS NOT INITIAL.
      result = |{ npa-name }@{ local_spec }|.
    ELSEIF npa-name IS NOT INITIAL.
      result = npa-name.
    ELSEIF local_spec IS NOT INITIAL.
      result = local_spec.
    ELSE.
      result = npa-raw.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
