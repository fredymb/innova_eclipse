@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Node Tree Hierarchy'
define hierarchy ZINN_I_NODETREE_HIER
  as parent child hierarchy(
    source ZINN_I_NODETREE
    child to parent association _Parent
    start where
      Nodeparent is initial
    siblings order by
      Nodename ascending
  )
{
  key Nodeid,
      Nodeparent
}
