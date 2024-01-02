@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Node Tree'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.hierarchy.recursiveHierarchy:[{ entity.name: 'ZINN_I_NODETREE_HIER' }]

define view entity ZINN_C_NODETREE
  as select from ZINN_I_NODETREE
  association of many to one ZINN_C_NODETREE as _Parent on $projection.Nodeparent = _Parent.Nodeid
{
     key Nodeid,     
      Nodename,
      Nodeparent,
      /* Associations */
      _Parent
}
